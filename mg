#!/usr/bin/env python3

import argparse
import asyncio
import json
import os
import shutil
from datetime import datetime
from pathlib import Path

XDG_DATA_HOME = Path(os.getenv("XDG_DATA_HOME") or "~/.local/share").expanduser()
XDG_CONFIG_HOME = Path(os.getenv("XDG_CONFIG_HOME") or "~/.config").expanduser()

RESET = "\033[0m"
RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
MAGENTA = "\033[35m"
CYAN = "\033[36m"
WHITE = "\033[37m"
BOLD = "\033[1m"
UNDERLINE = "\033[4m"


class PluginManager:
    def __init__(self):
        self.config_file = XDG_CONFIG_HOME / "nvim/plugins.json"
        self.state_file = XDG_DATA_HOME / "nvim/plugin_state.json"
        self.plugins_dir = XDG_DATA_HOME / "nvim/site/pack/plugins/opt"
        self.plugins_dir.mkdir(parents=True, exist_ok=True)
        self.plugins_state = self._load_state()
        self.state_changed = False

    def _load_state(self):
        if not self.state_file.exists():
            print(f"{YELLOW}Creating state file{RESET}")
            self.state_file.parent.mkdir(parents=True, exist_ok=True)
            self.state_file.write_text("{}")
            return {}
        with open(self.state_file, "r") as f:
            return json.load(f)

    def _save_state(self):
        if self.state_changed:
            try:
                self.state_file.parent.mkdir(parents=True, exist_ok=True)

                with open(self.state_file, "w") as f:
                    json.dump(self.plugins_state, f, indent=2)
            except (OSError, IOError) as e:
                print(f"{RED}Error saving state: {e}{RESET}")

    async def _run_git_async(self, args, cwd):
        process = await asyncio.create_subprocess_exec(
            "git",
            *args,
            cwd=str(cwd),
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
        )
        stdout, stderr = await process.communicate()

        if process.returncode != 0:
            raise Exception(f"Git command failed: {' '.join(args)}\n{stderr.decode()}")

        return stdout.decode().strip()

    async def _run_command(self, cmd, cwd):
        if cmd:
            print(f"{BLUE}Running{RESET} {GREEN}{cmd}{RESET} with {cwd.split('/')[-1]}")
            process = await asyncio.create_subprocess_shell(
                cmd,
                cwd=cwd,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
            )
            stdout, stderr = await process.communicate()
            if process.returncode != 0:
                print(f"{RED}Error:{RESET} {stderr.decode().strip()}")
            else:
                print(f"{stdout.decode().strip()}")

    def _format_log(self, log_output, repo, spaces: int):
        print(f"{UNDERLINE}{repo}{RESET}")
        current_time = datetime.now()

        for line in log_output.splitlines():
            commit_hash, commit_time, commit_message = line.split(" ", 2)
            commit_time = datetime.fromtimestamp(int(commit_time))
            time_diff = current_time - commit_time

            if time_diff.days > 0:
                time_str = (
                    f"{time_diff.days} day{'s' if time_diff.days > 1 else ''} ago"
                )
            elif time_diff.seconds >= 3600:
                hours = time_diff.seconds // 3600
                time_str = f"{hours} hour{'s' if hours > 1 else ''} ago"
            elif time_diff.seconds >= 60:
                minutes = time_diff.seconds // 60
                time_str = f"{minutes} minute{'s' if minutes > 1 else ''} ago"
            else:
                time_str = "just now"

            print(
                f"{' ' * spaces}{MAGENTA}{commit_hash}{RESET} {commit_message} {CYAN}({time_str}){RESET}"
            )

    async def _process_plugins(self, plugins, handler):
        tasks = [handler(repo, config) for repo, config in plugins.items()]
        await asyncio.gather(*tasks)

    async def _handle_install(self, repo, config):
        branch = config.get("branch", None)
        commit = config.get("commit", None)
        run_command = config.get("run", None)

        plugin_dir = self.plugins_dir / repo.split("/")[-1]
        if repo in self.plugins_state and plugin_dir.exists():
            return
        print(f"{BLUE}Installing{RESET} {repo}")
        if branch:
            await self._run_git_async(
                [
                    "clone",
                    "--depth",  # No "--depth 1"
                    "1",
                    "--recurse-submodules",
                    "--shallow-submodules",
                    "--branch",
                    branch,
                    f"https://github.com/{repo}.git",
                    str(plugin_dir),
                ],
                cwd=self.plugins_dir,
            )
        else:
            await self._run_git_async(
                [
                    "clone",
                    "--depth",
                    "1",
                    "--recurse-submodules",
                    "--shallow-submodules",
                    f"https://github.com/{repo}.git",
                    str(plugin_dir),
                ],
                cwd=self.plugins_dir,
            )

        try:
            actual_branch = await self._run_git_async(
                ["branch", "--show-current"], cwd=plugin_dir
            )
        except Exception:
            actual_branch = None

        commit = commit or await self._run_git_async(
            ["rev-parse", "HEAD"], cwd=plugin_dir
        )
        # Back to HEAD detached
        await self._run_git_async(["checkout", commit], cwd=plugin_dir)

        self.plugins_state[repo] = {
            "branch": branch or actual_branch or "",
            "commit": commit,
        }
        self.state_changed = True

        await self._run_command(run_command, str(plugin_dir))

    async def install(self):
        with open(self.config_file, "r") as f:
            plugins = json.load(f)

        await self._process_plugins(plugins, self._handle_install)

        self._save_state()

    async def _handle_update(self, repo, config):
        branch = config.get("branch", None) or self.plugins_state[repo].get(
            "branch", None
        )
        commit = config.get("commit", None)
        run_command = config.get("run", None)
        is_pin = config.get("pin", False)
        is_dev = config.get("dev", False)
        plugin_dir = self.plugins_dir / repo.split("/")[-1]

        if not plugin_dir.exists():
            return

        if commit:
            await self._run_git_async(["checkout", commit], cwd=plugin_dir)
            self.plugins_state[repo] = {
                "branch": branch,
                "commit": commit,
            }
        else:
            if is_pin or is_dev:
                return
            old_branch = self.plugins_state[repo]["branch"]
            if not branch or branch == "":
                default_branch = await self._run_git_async(
                    ["symbolic-ref", "refs/remotes/origin/HEAD"],
                    cwd=plugin_dir,
                )
                branch = default_branch.split("/")[-1]
            elif branch != old_branch:
                # Need to install plugin with new branch
                await self._remove_plugin(repo, plugin_dir)
                await self._handle_install(repo, config)

            await self._run_git_async(
                [
                    "fetch",
                    "--force",
                    "--tags",
                    "--recurse-submodules",
                    "--update-shallow",
                ],
                cwd=plugin_dir,
            )

        old_commit = self.plugins_state[repo]["commit"]
        new_commit = await self._run_git_async(
            ["rev-parse", f"origin/{branch}"], cwd=plugin_dir
        )

        if old_commit == new_commit:
            return

        log_output = await self._run_git_async(
            ["log", f"{old_commit}..{new_commit}", "--pretty=format:%h %ct %s"],
            cwd=plugin_dir,
        )
        self._format_log(log_output, repo, 2)

        user_input = (
            input(f"{YELLOW}Do you want to update {repo}? (y/n): {RESET}")
            .strip()
            .lower()
        )
        if user_input == "y":
            await self._run_git_async(["checkout", new_commit], cwd=plugin_dir)
            self.plugins_state[repo] = {
                "branch": branch,
                "commit": new_commit,
            }
            self.state_changed = True

            await self._run_command(run_command, str(plugin_dir))

    async def update(self):
        with open(self.config_file, "r") as f:
            plugins = json.load(f)

        missing_plugins = {}
        for key, value1 in plugins.items():
            if key not in self.plugins_state:
                missing_plugins[key] = value1

        await self.clean()
        # Install missing plugins
        await self._process_plugins(missing_plugins, self._handle_install)
        # Update exists plugins
        await self._process_plugins(plugins, self._handle_update)

        self._save_state()

    async def _remove_plugin(self, repo, plugin_dir):
        if plugin_dir.exists():
            print(f"{RED}Removing{RESET} {repo}")
            await asyncio.to_thread(shutil.rmtree, plugin_dir)
            del self.plugins_state[repo]
            self.state_changed = True

    async def clean(self):
        with open(self.config_file, "r") as f:
            plugins = json.load(f)

        installed_plugins = set(self.plugins_state.keys())
        configured_plugins = set(plugins.keys())

        tasks = [
            self._remove_plugin(repo, self.plugins_dir / repo.split("/")[-1])
            for repo in installed_plugins - configured_plugins
        ]

        await asyncio.gather(*tasks)

        self._save_state()

    async def sync(self, plugins=None):
        if plugins:
            for repo in plugins:
                plugin_dir = self.plugins_dir / repo.split("/")[-1]
                if plugin_dir.exists():
                    print(f"{RED}Removing{RESET} {repo}")
                    shutil.rmtree(plugin_dir)
                    del self.plugins_state[repo]
        else:
            if self.plugins_dir.exists():
                print(f"{RED}Removing all plugins{RESET}")
                shutil.rmtree(self.plugins_dir)
            self.plugins_dir.mkdir(
                parents=True, exist_ok=True
            )  # Recreate the plugins directory
            self.plugins_state.clear()

        await self.install()

    async def log(self, n=5):
        for repo in self.plugins_state.keys():
            plugin_dir = self.plugins_dir / repo.split("/")[-1]
            if not plugin_dir.exists():
                print(f"{repo} {YELLOW}not installed{RESET}")
                continue

            log_output = await self._run_git_async(
                ["log", "-n", str(n), "--pretty=format:%h %ct %s"], cwd=plugin_dir
            )
            self._format_log(log_output, repo, 2)


def main():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawTextHelpFormatter,
    )
    subparsers = parser.add_subparsers(
        dest="action", required=True, help="Available actions"
    )
    subparsers.add_parser(
        "install",
        help="Install all plugins from plugins.json",
    )
    subparsers.add_parser(
        "update",
        help="Update all installed plugins to the latest version",
    )
    subparsers.add_parser(
        "clean",
        help="Clean plugins not listed in plugins.json",
    )

    sync_parser = subparsers.add_parser(
        "sync",
        help="Clean all plugins and reinstall from plugins.json",
    )
    sync_parser.add_argument(
        "plugins",
        nargs="*",
        default=None,
        help="List of plugins to sync. If not provided, all plugins will be synced.",
    )

    log_parser = subparsers.add_parser(
        "log",
        help="Show the recent commits for all installed plugins",
    )
    log_parser.add_argument(
        "n",
        type=int,
        nargs="?",
        default=5,
        help="Number of recent commits to show for each plugin (default: 5)",
    )

    args = parser.parse_args()

    manager = PluginManager()

    try:
        if args.action == "install":
            asyncio.run(manager.install())
        elif args.action == "update":
            asyncio.run(manager.update())
        elif args.action == "clean":
            asyncio.run(manager.clean())
        elif args.action == "sync":
            asyncio.run(manager.sync(args.plugins))
        elif args.action == "log":
            asyncio.run(manager.log(args.n))
    except KeyboardInterrupt:
        print(f"\n{RED}Operation interrupted by user. Exiting...{RESET}")


if __name__ == "__main__":
    main()
