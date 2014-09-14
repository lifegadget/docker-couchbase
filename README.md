# Couchbase 
### Automated Image for Docker

> Developed by [LifeGadget](http://lifegadget.co) for [LifeGadget](http://lifegadget.co) but anyone is welcome to use

## Usage ##

- **Run**

	````bash
	sudo docker run -d \
		-v /host/mount/point:/data -e CB_PASSWORD=password \
		-p 11210:11210 -p 8091:8091 -p 8092:8092 \
		--name=COUCHBASE -t lifegadget/docker-couchbase
	````

	Running will force a download and build of the *docker-couchbase* environment to a locally executable container. After that the image will reside locally and the cached reference can be used. This cache, however, is not that useful because once started with `run` we will then just be manageing the resultant container with the commands below in the manage section.

	Assumptions/Comments:

	- 	**Data**. This installation of Couchbase installs and runs Couchbase as a daemon but the file system that data is stored on should be provided by the host container. You can point anywhere on the host you like but make sure that whatever is passed as the first parameter to the `-v` switch (aka, before the colon) is a valid filesystem on localhost.
	- 	**Username**. Currently this is not *settable* and just defaults to 'Adminstrator'
	- 	**Password**. Please set this password (e.g., the `CB_-_PASSWORD` environment variable passed in) to whatever you like and make sure to store it in a safe place as changing this isn't fun without the existing password.

- **Manage**

	- Process Execution	

		````bash
		# Start
		sudo docker start COUCHBASE
		# Stop
		sudo docker stop COUCHBASE
		# Restart
		sudo docker restart COUCHBASE
		````

	- Information

		````bash
		# Container details
		sudo docker inspect COUCHBASE
		# Logging/STDOUT of container
		sudo docker logs COUCHBASE
		````

## Details ##

For those that care about what lies within the container ...

- Couchbase will be installed to `/opt/couchbase` (the default location in Ubuntu)
- The installer will insert a bootstrap loader for couchbase at `/usr/sbin/couchbase`

 
## Versions ##

All versions of Couchbase use a base image of Ubuntu (currently 14.04). The list of available Couchbase 'versions' is broken up into both the build number and whether the build is 'community' or 'enterprise'. Currently the only available versions are Enterprise releases but in the future a branch for community will be created:

<table>
	<tr>
		<th>label</th>
		<th>vlabel</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>latest</td>
		<td>3.0.beta</td>
		<td>Couchbase Enterprise - Beta Release</td>
   </tr>
	<tr>
		<td>stable</td>
		<td>2.5.1</td>
		<td>Couchbase Enterprise 2.5.1 - Production Release</td>
   </tr>
</table>

## License

**docker-couchbase** was based on, but heavily modified from, [Dockerfile](https://gist.github.com/dustin/6605182). The rewrite was done by [Ken Snyder](http://ken.net) and made available under the under the [MIT license](https://github.com/broccolijs/broccoli/blob/master/LICENSE.md).