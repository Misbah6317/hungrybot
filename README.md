# Hungrybot

A hubot plugin for chat based, group food ordering. Now your team can order food to the office right from the chatroom!

## Table of Contents

 - [Installation](#installation)
 - [Usage](#usage)

## Installation

1. First you will need to have a Hubot set up, and Github has some great documentation on that [here](https://github.com/github/hubot/blob/master/docs/README.md), and if you want to set your bot to listen to specific chat backends, you can find that [here](https://github.com/github/hubot/blob/master/docs/adapters.md)!

2. Clone this repository in your Hubot's root directory.

        git clone https://github.com/ordrin/hungrybot.git

3. Add food.coffee to your Hubot scripts/ directory.

        cp hungrybot/food.coffee scripts/food.coffee

4. Now Hubot will recognize the foodbot plugin, but more setup is required. Run the setup.coffee script in order to create an account with Ordr.in. This is where you will keep your credit card and address information that will be used for group orders. You should have coffeescript installed already because it is required for Hubot to run.

        coffee setup.coffee

5. We are almost done! Now that you have created an Ordrin account, you must set some environment variables. If you are using Heroku you can figure out how to do this [here](https://devcenter.heroku.com/articles/config-vars). Set the following variables:

```
export HUBOT_ORDRIN_EMAIL="Your Ordrin account's email address."
export HUBOT_ORDRIN_PASSWORD="Your Ordrin account's password."
export HUBOT_ORDRIN_FIRST_NAME="The first name that you used for your Ordrin account."
export HUBOT_ORDRIN_LAST_NAME="The last name that you used for your Ordrin account."
```

You should now be able to start using your Hubot to place food orders!

## Usage

### Starting an order

You can start an order like this

    foodbot start order

Which will initiate a group order, having the bot populate a list of restaurant suggestions.

If you want something more specific, like a restaurant name or cuisine type, you can give the bot a search query as well.

    footbot start order pizza
