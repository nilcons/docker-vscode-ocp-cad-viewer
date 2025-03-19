FROM debian:12
RUN apt-get update && apt-get install -y pip python3-venv libgl1 libxrender1 && rm -rf /var/lib/apt/lists/*
RUN python3 -m venv /venv
COPY ocp-vscode.version cadquery-ocp.version /
RUN /venv/bin/pip install ocp-vscode==$(cat ocp-vscode.version) cadquery-ocp==$(cat cadquery-ocp.version)
# This --help test run just makes sure that all dependencies are
# correctly installed, e.g. with missing libxrender or libgl1 we get
# an exit value of non-zero that stops the docker build.
RUN /venv/bin/python3 -m ocp_vscode --help

# Temporary hack to get rid of scrollbars, until 2.6.5.
RUN sed -i '/const standaloneViewer/s/$/ document.body.style.overflow = "hidden";/' venv/lib/python3.11/site-packages/ocp_vscode/standalone.py

EXPOSE 3939
ENTRYPOINT ["/venv/bin/python3", "-m", "ocp_vscode", "--host", "0.0.0.0"]
