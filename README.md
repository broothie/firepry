# 🔥💎 firepry

A [Firestore](https://cloud.google.com/firestore) REPL that's actually just [Pry](https://github.com/pry/pry).

## About

It's nice to be able to drop into a SQL console when you need to wrangle some queries. There's no real "native" way to
do this, so **`firepry`** serves as way to drop into a Pry (Ruby) REPL with your Firestore DB loaded up in a local
(`firestore` or `db`).

### Why Pry/Ruby?

I'm probably biased because I've worked with Ruby/Rails quite a bit, but the DSL-ish nature of Ruby lends itself very
well to being used as a Firestore DB REPL. Should be (hopefully) quick to learn for users of most languages.

## Usage

Installation:

```shell
$ gem install firepry
```

Help text:

```shell
$ firepry -h
Usage: firepry [options]
    -p, --project-id PROJECT-ID      GCP project ID
    -k, --keyfile KEYFILE            GCP keyfile
    -e, --endpoint ENDPOINT          Firestore endpoint URL
```

A few different ways to start it:
```shell
$ firepry                            # if $FIRESTORE_CREDENTIALS is already set up in your environment
$ firepry -k gcloud-key.json         # where `gcloud-key.json` is your GCP keyfile 
$ firepry -p asdf -e localhost:5001  # if you're using a local emulator
```

To issue queries, etc...:

```shell
# Get doc by id
[1] firepry(db)> collection('users').doc('user_id_blahblahblah').get.data
# Get first doc in collection
[2] firepry(db)> collection('users').get.first.data
# Query collection
[3] firepry(db)> collection('users').where('follower_count', '>', 1_000_000).get
```

More info:
- [Ruby Firestore GitHub](https://github.com/googleapis/google-cloud-ruby/tree/master/google-cloud-firestore)
- [Firestore Docs](https://firebase.google.com/docs/firestore/manage-data/add-data#ruby)


## How it works

Here's all the code:

```ruby
#! /usr/bin/env ruby
require 'dotenv/load'
require 'optparse'
require 'pry'
require 'google/cloud/firestore'
require 'firepry'

firestore_options = {}
OptionParser.new do |opts|
  opts.banner = "firepry v#{FirePry::VERSION}\nUsage: firepry [options]"

  opts.on('-v', '--version', 'Show version') { puts "firepry v#{FirePry::VERSION}"; exit }
  opts.on('-p', '--project-id PROJECT-ID', 'GCP project ID') { |opt| firestore_options[:project_id] = opt }
  opts.on('-k', '--keyfile KEYFILE', 'GCP keyfile') { |opt| firestore_options[:keyfile] = opt }
  opts.on('-e', '--endpoint ENDPOINT', 'Firestore endpoint URL') { |opt| firestore_options[:endpoint] = opt }
end.parse!

@firestore = Google::Cloud::Firestore.new(**firestore_options)

def current_obj(obj)
  obj == @firestore ? 'db' : obj
end

line = 0
Pry.start(
  @firestore,
  prompt: Pry::Prompt.new(
    'firepry',
    'the firepry prompt',
    [proc { |obj, nest_level, _| "[#{line += 1}] firepry(#{current_obj(obj)})> " }]
  )
)
```

## Attributions

- https://github.com/pry/pry
- https://cloud.google.com/firestore
