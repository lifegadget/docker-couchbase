# Couchbase 
### Automated Image for Docker

> Developed by [LifeGadget](http://lifegadget.co) for LifeGadget but anyone's welcome to use
 
## Usage ##

- **Build**

	````bash
	sudo docker build -t couchbase:latest git:
	````	

- **Run**

	````bash
	sudo docker run -d \
		-v /path/to/data:/data -e CB_PASSWORD=password \
		-p 11210:11210 -p 8091:8091 -p 8092:8092 \
		--name=COUCHBASE lifegadget/env-couchbase
	````

	Assumptions/Comments:

	- 	**Data**. This installation of Couchbase installs and runs Couchbase as a daemon but the file system that data is stored on should be provided by the host container. You can point anywhere on the host you like but make sure that whatever is passed as the first parameter to the `-v` switch is a valid filesystem on localhost.
	- 	**Username**. Currently this is not *settable* and just defaults to 'Adminstrator'
	- 	**Password**. Please set this password (e.g., the `CB_-_PASSWORD` environment variable passed in) to whatever you like and make sure to store it in a safe place as changing this isn't fun without the existing password.

&nbsp;
	
- **Other options**

	> To be filled in

- **Build Only**

	To build the couchbase environment locally but *not* run, then:

	````bash
	sudo docker build -d \
		-v /path/to/data:/data -e CB_PASSWORD=password \
		--name=COUCHBASE lifegadget/couchbase
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