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
$ firepry                    # if $FIRESTORE_CREDENTIALS is already set up in your environment
$ firepry -k gcloud-key.json # where `gcloud-key.json` is your GCP keyfile 
$ firepry -p asdf -e localhost:5001  # if you're using a local emulator
```

To issue query:

```shell
$ firepry
[1] pry(main)> db.collection('users').doc('user_id_blahblahblah').get.data
{
  username: 'broothie',
  more_data: 'goes here'
}
```

More info:
- [Ruby Firestore GitHub](https://github.com/googleapis/google-cloud-ruby/tree/master/google-cloud-firestore)
- [Firestore Docs](https://firebase.google.com/docs/firestore/manage-data/add-data#ruby)


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

## Attributions

- https://github.com/pry/pry
