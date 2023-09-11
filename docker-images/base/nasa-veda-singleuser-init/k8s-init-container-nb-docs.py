import subprocess
import argparse


def clone_veda_docs(target_home_path):
    try:
        target_path = os.path.join(target_home_path, "veda-docs-examples")
        result = subprocess.run(
            ["gitpuller", "https://github.com/NASA-IMPACT/veda-docs/", "main", target_path],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True  # Capture output as a string instead of bytes
        )
        print(f"Command stdout:\n{result.stdout}")
        print(f"Command stderr:\n{result.stderr}")
    except subprocess.CalledProcessError as e:
        print(f"Command failed with error {e.returncode}, stderr:\n{e.stderr}")
        raise


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("target", help="The target home path which should exist.")
    args = parser.parse_args()
    clone_veda_docs(args.target)