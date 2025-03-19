# Standalone mode ocp-cad-viewer with Docker

This is Docker packaging for https://github.com/bernhard-42/vscode-ocp-cad-viewer .

The advantage of Docker is that it keeps the Flask based standalone web viewer in separated environment.

You will still have to of course pip install `ocp_vscode` and `build123d` into the venvs where you work,
but those packages are pure Python, without dependencies like xrender or libgl.

## Starting the docker container and opening the viewer

First of all, you have to run the container that provides the web server:

```
docker run -it --rm -p 3939:3939 ghcr.io/nilcons/cad-viewer
```

Once, this is running, you can visit `localhost:3939`.

Alternatively you can make a full window app out of it like this:

```
#!/bin/bash

set -euo pipefail

docker run --name cadview --detach -p 3939:3939 --rm ghcr.io/nilcons/cad-viewer --reset_camera keep || true
google-chrome --user-data-dir=$HOME/ocp-dedicated-chrome-data-dir --app=http://localhost:3939/
```

The `docker run` part's errors are ignored, so if the container is already running, the chrome window still opens.

This example also shows that you can pass in the usual `vscode-ocp-cad-viewer` command line flags at the end of the `docker run` command.
To get a list of supported flags you can run `docker run --rm ghcr.io/nilcons/cad-viewer --help`.

## Sending data to the viewer for display

Once your browser is connected, you can send data to it as normal with `ocp_vscode`'s `show` functions:

```python
from build123d import *
from ocp_vscode import *

b = Box(1,2,3)
show(b)
```

Of course, in the venv where you are running this, `build123d` and `ocp_vscode` has to be pip installed.
