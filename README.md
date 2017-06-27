xds-exec: wrapper on exec for XDS
=================================

`xds-exec` is a wrapper on exec linux command for X(cross) Development System.

As well as `xds-exec` is a wrapper on exec command and can be use to execute any
command on a remote `xds-server`.

This tool can be used in lieu of "standard" `exec` command to execute any
command on a remote `xds-server`. For example you can trig your project build by
executing : `xds-exec --config conf.env -- make build`

> **SEE ALSO**:
>  - [xds-agent](https://github.com/iotbzh/xds-agent), an agent that should run
on your local host in order to use XDS.
>  - [xds-server](https://github.com/iotbzh/xds-server), a web server
used to remotely cross build applications.

## Getting Started

You must have a running `xds-server` (locally or on the Cloud), see
[README of xds-server](https://github.com/iotbzh/xds-server/blob/master/README.md)
for more details.

Connect your favorite Web browser to the XDS dashboard (default url
http://localhost:8000) and follow instructions to start local `xds-agent` on
your local host. Please refer to instructions provided by XDS dashboard or see
`README of xds-agent`.

Then create your project you XDS dashboard.

You need to determine which is the unique id of your project. You can find
this ID in project page of XDS dashboard or you can get it from command line
using the `--list` option. This option lists all existing projects ID:
```bash
./bin/xds-exec --list

List of existing projects:
  CKI7R47-UWNDQC3_myProject
  CKI7R47-UWNDQC3_test2
  CKI7R47-UWNDQC3_test3
```

Now to refer your project, just use --id option or use `XDS_PROJECT_ID`
environment variable.

You are now ready to use XDS to for example cross build your project.
Here is an example to build a project based on CMakefile:
```bash
# Add xds-exec in the PATH
export PATH=${PATH}:${path_where_xds-exec_is_install}

# Create a build directory
xds-exec --id=CKI7R47-UWNDQC3_myProject --sdkid=poky-agl_aarch64_3.99.1+snapshot --url=http://localhost:8000 -- mkdir build

# Generate build system using cmake
xds-exec --id=CKI7R47-UWNDQC3_myProject --sdkid=poky-agl_aarch64_3.99.1+snapshot  --url=http://localhost:8000 -- cd build && cmake ..

# Build the project
xds-exec --id=CKI7R47-UWNDQC3_myProject --sdkid=poky-agl_aarch64_3.99.1+snapshot  --url=http://localhost:8000 -- cd build && make all
```

To avoid to set project id, xds server url, ... at each command line, you can
define these settings as environment variable within an env file and just set
`--config` option. For example, the equivalence of above command is:
```
cat config.env
  XDS_SERVER_URL=localhost:8000
  XDS_PROJECT_ID=CKI7R47-UWNDQC3_myProject
  XDS_SDK_ID=poky-agl_aarch64_3.99.1+snapshot

xds-exec --config config.env -- mkdir build
xds-exec --config config.env -- cd build && cmake ..
xds-exec --config config.env -- cd build && make all
```

## How to install xds-exec

### Install package for debian distro type

```bash
export DISTRO="Debian_8.0"
wget -O - http://download.opensuse.org/repositories/isv:/LinuxAutomotive:/app-Development/${DISTRO}/Release.key | sudo apt-key add -
sudo bash -c "cat >/etc/apt/sources.list.d/AGL.list<<EOL
#AGL
deb http://download.opensuse.org/repositories/isv:/LinuxAutomotive:/app-Development/${DISTRO}/ ./
EOL
"
sudo apt-get update
sudo apt-get install agl-xds-exec-bin
```

The value 'DISTRO' can be set to {Debian_8.0, Debian_9.0, xUbuntu_16.04, xUbuntu_16.10, xUbuntu_17.04}

Update the package
```bash
sudo apt-get update
sudo apt-get upgrade agl-xds-exec-bin
```

The files are install here:
```bash
/opt/AGL/agl-xds-exec
```

### Install package for rpm distro type

#### openSUSE
```bash
export DISTRO="openSUSE_Leap_42.2"
sudo zypper ar http://download.opensuse.org/repositories/isv:/LinuxAutomotive:/app-Development/${DISTRO}/isv:LinuxAutomotive:app-Development.repo
sudo zypper ref
sudo zypper install agl-xds-exec
```

The value 'DISTRO' can be set to {openSUSE_Leap_42.2, openSUSE_Leap_42.3, openSUSE_Tumbleweed}

Update the package
```bash
sudo zypper ref
sudo zypper install --force agl-xds-exec
```

The files are install here:
```bash
/opt/AGL/agl-xds-exec
```

## How to build

### Prerequisites
 You must install and setup [Go](https://golang.org/doc/install) version 1.7 or
 higher to compile this tool.

### Building
Clone this repo into your `$GOPATH/src/github.com/iotbzh` and use delivered Makefile:
```bash
 export GOPATH=$(realpath ~/workspace_go)
 mkdir -p $GOPATH/src/github.com/iotbzh
 cd $GOPATH/src/github.com/iotbzh
 git clone https://github.com/iotbzh/xds-exec.git
 cd xds-exec
 make
```

## Debug

Visual Studio Code launcher settings can be found into `.vscode/launch.json`.

>**Tricks:** To debug both `xds-exec` (client part) and `xds-server` (server part),
it may be useful use the same local sources.
So you should replace `xds-server` in `vendor` directory by a symlink.
So clone first `xds-server` sources next to `xds-exec` directory.
You should have the following tree:
```
> tree -L 3 src
src
|-- github.com
    |-- iotbzh
       |-- xds-exec
       |-- xds-server
```
Then invoke `vendor/debug` Makefile rule to create a symlink inside vendor
directory :
```bash
cd src/github.com/iotbzh/xds-exec
make vendor/debug
```
