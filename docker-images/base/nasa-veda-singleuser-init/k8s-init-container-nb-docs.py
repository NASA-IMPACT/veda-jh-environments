import subprocess
import argparse
import os


def clone_veda_docs(target_home_path):
    try:
        target_path = os.path.join(target_home_path, "veda-docs-examples")
        result = subprocess.run(
            ["/home/jovyan/.local/bin/gitpuller", "https://github.com/NASA-IMPACT/veda-docs/", "main", target_path],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True  # Capture output as a string instead of bytes
        )
        print(f"command stdout:\n{result.stdout}")
        print(f"command stderr:\n{result.stderr}")

        result = subprocess.run(
            ["chown", "-R", "jovyan:jovyan", target_path],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True  # Capture output as a string instead of bytes
        )
        print(f"chown stdout:\n{result.stdout}")
        print(f"chown stderr:\n{result.stderr}")
    except subprocess.CalledProcessError as e:
        print(f"Command failed with error {e.returncode}, stderr:\n{e.stderr}")
        raise


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("target", help="The target home path which should exist.")
    args = parser.parse_args()
    clone_veda_docs(args.target)