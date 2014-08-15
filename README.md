# Hungrybot

A hubot plugin for chat based, group food ordering. Now your team can order food to the office right from the chatroom!

## Table of Contents

 - [Installation](#installation)
 - [Usage](#usage)

## Installation

1. First you will need to have a Hubot set up, and Github has some great documentation on that [here](https://github.com/github/hubot/blob/master/docs/README.md), and if you want to set your bot to listen to specific chat backends, you can find that [here](https://github.com/github/hubot/blob/master/docs/adapters.md)!

2. Clone this repository in your Hubot's root directory.

        git clone https://github.com/ordrin/hungrybot.git

3. Install all of our dependencies into your hubot project directory.

        npm install underscore --save
        npm install ordrin-api --save
        npm install request --save
        npm install async --save
        npm install prompt --save

3. Add food.coffee to your Hubot scripts/ directory.

        #cd into the root directory of your hubot project
        cp hungrybot/food.coffee scripts/food.coffee

4. Now Hubot will recognize the foodbot plugin, but more setup is required. Run the setup.coffee script in order to create an account with Ordr.in. This is where you will keep your credit card and address information that will be used for group orders. You should have coffeescript installed already because it is required for Hubot to run.

        #cd into the root directory of your hubot project
        cp hungrybot/setup.coffee .
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

For these examples, we named our bot "foodbot". You can use whatever name you like for your bot, especially if you are just adding this script to a pre-existing bot.

All of these commands involved in communicating with the bot must be explicitly directed towards the bot, by referencing his name in the chat.

### Starting an order

After running the foodbot in your team's chat, you can start an order like this

    foodbot start order

Which will initiate a group order, having the bot populate a list of restaurant suggestions.

If you want something more specific, like a restaurant name or cuisine type, you can give the bot a search query as well.

    footbot start order Thai

Whoever starts the order is designated the "leader" and will be the main person that the bot answers to when making decisions for the group.

### Selecting a restaurant

Now that you have started an order, you will be presented with a list of possible restaurants to choose from. The group can discuss which restaurant to pick, and the leader tells the bot by either saying the number corresponding to the restaurant, or the full name of the restaurant.

```
Foodbot: sagnew is the leader, and has started a group order. Wait while I find some cool nearby restaurants.

foodbot: Tell me a restaurant to choose from: (0) Bangkok 2 Thai, (1) ABE Potluck Asian, (2) Little Basil, (3) Erawan, (4) Thai Palace, (5) East Pacific,  (say "more" to see more restaurants)

sagnew: foodbot 2

Alright lets order from Little Basil! They serve Thai, Vegetarian, and Fusion. Everyone enter the name of the item from the menu that you want. sagnew, tell me when you are done. Tell me "I'm out" if you want to cancel your order.
```

You are now ordering from the restaurant of your choice!

### Choosing food to order

Now that a restaurant has been chosen, any user who wishes to join in on the order may do so by telling the bot what type of food items he or she wants. This is done by saying "*botname* I want *food item*"

The bot will go through the menu to find possible matches to what you asked for. It will give you a list of items to choose from, and you can select them by saying the number. Any message works as long as it ends with the number corresponding to the food item you wish to order.

```
sagnew: foodbot I want pineapple fried rice with chicken

foodbot: sagnew how about any of these?: (0) Pineapple Fried Rice with Chicken and Tom Yum Chicken - $11.00, (1) Pineapple Fried Rice Lunch with Tom Yum Chicken - $9.00, (2) Thai Fried Rice with Chicken - $11.00, (3) Thai Fried Rice Lunch Entree with Chicken and Tom Yum Chicken - $8.00, (4) Little Basil Fried Rice with Chicken - $11.00, (5) Pad Thai with Chicken - $11.00,  tell me "no" if you want something else, and "more" to see more options.

sagnew: foodbot Awesome! You got it right on the first try! I'll go with 0
```

After selecting a food item, you will be prompted to either continue ordering, or to stop. You can continue ordering by simply asking for another specific food item, or by saying no.

```
foodbot: Cool. sagnew is getting Pineapple Fried Rice with Chicken and Tom Yum Chicken. sagnew, do you want anything else?

sagnew: foodbot no thanks!

foodbot: sagnew, hold on while everyone else orders!
```

### Placing the order

Once everyone is finished, the leader may tell the foodbot that the order is done, and ready to be placed by saying "*botname* done"
You will be asked to confirm everything one last time before finally placing the order. If the order is incorrect just tell the bot no, and if everything is right then say "*botname* place order" to go through with it.

NOTE: Currently this *will* charge the credit card, and deliver to the address used in the setup steps.

```
foodbot:
  Awesome! Lets place this order. Here is what everyone wants:
  sagnew: Pineapple Fried Rice with Chicken and Tom Yum Chicken

Is this correct? sagnew tell me "place order" when you are ready, and "no" if you wish to keep ordering.

sagnew: foodbot place order

foodbot: Placing order. Please wait for me to confirm that everything was correct.
```

A few seconds will pass as the HTTP request gets sent, and all of the data gets verified. After receiving a response, the bot will let you know the status of the order.

```
foodbot: Order placed: Success
```

Now your food is on its way! (Assuming you entered all of the correct delivery information that is!) If there were any problems, the bot will return an error message.
