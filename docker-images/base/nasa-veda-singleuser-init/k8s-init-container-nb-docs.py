import subprocess
import argparse
import os
import sys
import logging

logger = logging.getLogger("k8s-init-veda-docs")
logging.basicConfig(
    filename='/home/jovyan/_init_.log',
    level=logging.DEBUG,
    format='%(asctime)s [%(levelname)s] - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)


def clone_veda_docs(target_home_path):
    target_path = os.path.join(target_home_path, "veda-docs")
    cmd = ["gitpuller", "https://github.com/NASA-IMPACT/veda-docs/", "main", target_path]
    logger.debug(f"[ EXECUTING ]: {cmd}")
    result = subprocess.run(
        cmd,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True  # Capture output as a string instead of bytes
    )
    logger.debug(f"gitpuller stdout:\n{result.stdout}")
    logger.error(f"gitpuller stderr:\n{result.stderr}")

    cmd = ["chown", "-R", "1000:1000", target_path],
    logger.debug(f"[ EXECUTING ]: {cmd}")
    result = subprocess.run(
        cmd,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    logger.debug(f"chown stdout:\n{result.stdout}")
    logger.error(f"chown stderr:\n{result.stderr}")


if __name__ == '__main__':
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("target", help="The target home path which should exist.")
        args = parser.parse_args()
        clone_veda_docs(args.target)
    except subprocess.CalledProcessError as e:
        logger.error(f"Command failed with error {e.returncode}, stderr:\n{e.stderr}")
    except Exception as e:
        logger.error(f"Command failed with error {e.returncode}, stderr:\n{e.stderr}")
    finally:
        # force the initContainer never to fail so users still progress to the next image
        sys.exit(0)
