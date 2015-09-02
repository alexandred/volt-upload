# Volt::Upload

File upload support for Volt. Supports storing to the database, local storage and Cloudinary (using the cloudinary gem and cloudinary_js). Based on code by @andrew-carroll

## Installation
You must first add the following line to your application's Gemfile:

	gem 'cloudinary_gem', github: "alexandred/cloudinary_gem"

In the future (once a few issues have been sorted), this should be unecessary.

Add this line to your application's Gemfile:

    gem 'volt-upload', github: "alexandred/volt-upload"

And then execute:

    $ bundle install

Add this line to your component's `dependencies.rb` file:

    component 'upload'

## Setup

We shall use the following example: a user collection that has a picture, some photos and a PDF file. We shall first create a collection which contains the logic of your storage. In your component, add the following model:
	
	class Attachment < StorageBase
	end

By default, volt-upload assumes that the name of this class is `Attachment` but you may name it whatever you like and provide the class name in the logic to come.

We can now describe the files on the user collection in the attachment collection as follows:
	
	saves :picture, for: :user, in: :db
	saves :photos, for: :user, in: :cloudinary
	saves :pdf, for: :user, in: :local

A default container for the storage can be provided as follows:

	default_container :db

The supported containers are:
	* `db` - database
	* `local` - local storage
	* 'cloudinary' - in a cloudinary cloud

We now have to complement the storage logic inside the user collection. Insert the following into your component's user collection:

	attachment :picture
	attachments :photos
	attachment :pdf

If you want to provide a custom `StorageBase` class, you can just pass the collection name as follows:

	attachment :picture, collection: :picture

## Usage

	Continuing the user example, we will add an input field for the picture attachment for the current user. Add the following to the relevant form:

	<:upload:main collection="{{ Volt.current_user }}" attachment="picture"/>

	To show the image after a successful upload (attachments stored in the cloudinary container require a refresh to show), you can use the following:

	{{ raw Volt.current_user.picture.then {|picture| "#{picture.url}" } }}

	This binding will be simplified greatly in future versions.

## Local Storage

	Attachments that are saved in the local container are currently saved in "app/{component name}/assets/static". This will be changed to "public" in future versions.

## Cloudinary

	You must provide a configuration file for your Cloudinary cloud. volt-upload expects to find it at "config/cloudinary.yml". To download an automatically generated config file, visit this page: https://cloudinary.com/console/cloudinary.yml

	volt-upload provides a 'cloudinary_url' (instead of url) helper to generate a URL using Cloudinary transforms. For example:

	`cloudinary_url(width: 50, height: 50, gravity: "face", crop: "fill")`

	will generate a URL for an image that is 50x50 pixels^2 with face detection.


## Help
	
	If you have any problems with this component, feel free to contact @alexandred at gitter.im/voltrb/volt.

## Credits

	* Ryan Stout for the fantastic Volt framework
	* Andrew Caroll for the base uploading functionality and inspiration
	* The rest of the Volt framework contributors
