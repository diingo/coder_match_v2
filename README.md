# CoderMatch

A not so simple app to match coders together for learning, pair-programming, making friends and fun.

## User Stories (MVP)
1. As a user, I want to be able to pair or create a learning group based on:
  - A specific point in learning a language
    - Ex: Ch 4 of Learn You a Haskell
- As a user, I want to be able to login through github
- As a user, I want to have a profile that:
  - Shows topics I want to create a group for or pair on
  - Shows whether I'm interested in remote/local pairing or both
  - Shows proximity of where I'd like to meet up on a map - a radius
- As a user, I want to be able to find other users to group/pair with

### APIS
- MapBox
- GitHub
- Muut

## Current TO DO
x use case - create interest
x db create and get interest
- update database_spec to have expectation that returned values are entities
- use case - create user
- db update create use to have new attr_accessors

## Later Fixes
- Geocoder doesn't return nil for some invalid coords - ex, 101 Mario Cart World, Austin, Tx returns the coords for Austin, Tx
- Create Use use case - figure out how to stub Geocoder.coordinates

## User Stories (later)

- As a user, I want to be able to pair or create a learning group based on:
  - A specific framework
    - Ex: Sails.js, Famous, etc
  - A specific point in learning a language
    - Ex: Ch 4 of Learn You a Haskell
  - A project and what stack and/or APIs it uses:
    - A chat app that uses node
    - A rails app that uses angular
  - An API:
    - Twitter, Github
  - Concepts:
    - AJAX, JQuery, HTTP, using APIs
    - Testing
- As a user, I want to have a profile that:
  - Shows projects that represent my skill
  - Shows projects I want to pair on
  - Shows topics I want to create a group for or pair on
  - Shows whether I'm interested in remote/local pairing or both
  - Shows proximity of where I'd like to meet up on a map - a radius
  - Shows my questions/learning points
- As a user, I want to communicate with other users:
  - Through tokenized buttons - like linkedin
  - Accept, create or reject invitations to group or pair
  - Turn off or on availability for invitations
- As a user, I want to receive info/mail:
  - On other new users I may be interested in pairing/grouping with
  - Updates on old users that may make them good for pairing with
- As a user, I want to be able to comment:
  - On other user's code (learning from receiving and giving critiques in a friendly environment)
- As a user, I want to be rewarded
  - Get badges/upvotes for my efforts to comment on other user's code
  - Get badges/upvotes for learning new concept, joining new groups, pairing with more people, progressing
- As a user, I want to stay connected with my group and pairs
  - Groups have pages that update
    - where they're at in reading/points of learning
  - A pairs update/feed showing what new technology a pair picking up, projects they're working on



