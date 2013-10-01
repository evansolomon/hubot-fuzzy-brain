# Hubot Fuzzy Brain

Give Hubot fuzzy-searchable memories.

Sometimes we want Hubot to remember something, like how to find some information. But then we forget what we told Hubot to remember. Thankfully, Hubot can be smarter than us.

Hubot can run a fuzzy search on its memory, thanks to [fuzzyset.js](https://github.com/Glench/fuzzyset.js).

### Install

Not on NPM yet...

`npm install --save git://github.com/evansolomon/hubot-fuzzy-brain.git`

### Example

```
Silly Human> hubot learn how to start the server is run npm start
Silly Human> hubot how do i start the server?
Smart Robot> Silly Human: run npm start
Silly Human> hubot how do i make the server run?
Smart Robot> Silly Human: I think you want to know how to: start the server
             It's probably: run npm start
```
