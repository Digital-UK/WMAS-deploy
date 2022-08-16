# WMAS Deployment

## Requirements

- Docker v18 or higher
- docker-compose v1.18 or higher

## Create the image

The server is deployed in a virtual environment. An image with the desired version is required to run it. To build an image run the following command, passing a commit id:

```
$ sudo ./build.sh <commit id/branch/version tag> <image-tag>
```

For example:

```
$ sudo ./build.sh wmas2020 latest
```

```
$ sudo ./build.sh wmas2020-v1.0.2 1.0.2
```

## Run the image in a container

What image version to use when creating a container is defined inside the `docker-compose.yml`. By default it is `latest`. To run the image in a docker container, make sure directories `data` and `results` exist with ownership `uid=1000,gid=1000`. Then run the following command:

```
$ sudo docker-compose up
```

Run it in background

```
$ sudo docker-compose up -d
```

Note that upon first start, generating the MANIFEST.json can take some time. Restarting the server should be significantly faster.

For more information on how to use and configure the server, please refer to the [documentation](https://github.com/cta-wave/WMAS/tree/wmas2020/tools/wave/docs).

## Access test runner

The test runner uses multiple domains to execute the tests and to access the landing and control pages. There are two ways to resolve these domains to the correct IP:

### hosts-file

When running the test runner locally on a single machine the domains can be added to the hosts file of the machine. On Linux and Mac, take the entries listed in [hosts-linux](./hosts-linux.txt) and copy them into the `/etc/hosts` file. On Windows, take the entries from [hosts-windows](./hosts-windows.txt) and copy them into the `C:\Windows\System32\drivers\etc\hosts` file.

This will allow to access the landing page under `web-platform.test/_wave/`.

### DNS server

When running the test runner on a device separate from the DUT, the easiest way for the DUT to resolve the domains is to use the built-in DNS server as described under [Networking Deployment](#network-deployment).  
Of course this can also be used for a setup on a single machine.

The landing page can then be accessed under `web-platform.test/_wave/`.


## View logs

To display the logs, simply run:

```
$ sudo docker logs wmas2020
```

## Start, Stop and Restart existing container

You can control an existing container with a set of commands.

Start container:

```
$ sudo docker start wmas2020
```

Stop container:

```
$ sudo docker stop wmas2020
```

Restart container:

```
$ sudo docker restart wmas2020
```

## Update to new version

To update to a new version the image needs to be recreated with the new commit, just as described in [Create the image](#create-the-image).

## Network deployment

To make the test runner accessible by other devices in a network, put the host machine's IP address into the `TEST_RUNNER_IP` environment variable and use the commented port configuration `- 53:53/udp` in the `docker-compose.yml`, to configure the built-in DNS server properly. Alternatively, you can set up your own DNS server that resolves all domains listed in the `docker-compose.yml`s `extra_host` list to the host machines IP address. Then configure the DUT's or the router's DNS accordingly.

### SSL

To utilize the SSL certificates for your domain, make sure the directory `certs` exists with ownership `uid=1000,gid=1000` and put them in there. Then change the path to the certificates in `config.json` to something similar to `./certs/your-key.pem`.
