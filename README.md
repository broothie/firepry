# 🔥💎 firepry

A Firestore REPL that's actually just Pry.

## About

It's nice to be able to drop into a SQL console when you need to wrangle some queries. There's no real "native" way to
do this, so **`firepry`** serves as way to drop into a Pry (Ruby) REPL with your Firestore db loaded up in a local
(`firestore` (or `db`)).

## Usage

Here's the help text:

```bash
$ firepry -h
Usage: firepry [options]
    -p, --project-id PROJECT-ID      GCP project ID
    -k, --keyfile KEYFILE            GCP keyfile
    -e, --endpoint ENDPOINT          Firestore endpoint URL
```

Here's some example usage:

```bash
$ firepry
[1] pry(main)> db
=> #<Google::Cloud::Firestore::Client:0x00007f982b914180 @service=Google::Cloud::Firestore::Service(project-id)>
[2] pry(main)> db.collection('users')
> #<Google::Cloud::Firestore::CollectionReference:0x00007f98272912a8
 @client=#<Google::Cloud::Firestore::Client:0x00007f982b914180 @service=Google::Cloud::Firestore::Service(project-id)>,
 @path="projects/project-id/databases/(default)/documents/users",
 @query=<Google::Cloud::Firestore::V1::StructuredQuery: from: [<Google::Cloud::Firestore::V1::StructuredQuery::CollectionSelector: collection_id: "users", all_descendants: false>], order_by: [], offset: 0>>
```

[Here's](https://github.com/googleapis/google-cloud-ruby/tree/master/google-cloud-firestore) a link to the Github docs.

And [here's](https://firebase.google.com/docs/firestore/manage-data/add-data#ruby) a link to the Firestore docs, just be sure to select `Ruby` in the code examples. 

## How it works

Here's all the code:

```ruby
#! /usr/bin/env ruby
require 'optparse'
require 'pry'
require 'google/cloud/firestore'

firestore_options = {}
OptionParser.new do |opts|
  opts.on('-p', '--project-id PROJECT-ID', 'GCP project ID') do |opt|
    firestore_options[:project_id] = opt
  end

  opts.on('-k', '--keyfile KEYFILE', 'GCP keyfile') do |opt|
    firestore_options[:keyfile] = opt
  end

  opts.on('-e', '--endpoint ENDPOINT', 'Firestore endpoint URL') do |opt|
    firestore_options[:endpoint] = opt
  end
end.parse!

@firestore = Google::Cloud::Firestore.new(**firestore_options)

def firestore
  @firestore
end
alias db firestore

Pry.start
```
