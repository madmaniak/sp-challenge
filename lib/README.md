Libs
====

##Sponsor Action

Helps in consuming SponsorPay API.

###Configuration

Define ```SPConfig``` in main scope e.g. by YAML file:

```ruby
  uri: api.sponsorpay.com/feed
  version: 1
  api_key: 1234567890123456789012345678901234567890
  appid: 123
  device_id: 0987654321098765432109876543210987654321
  ip: 217.96.145.138
  locale: de
```

Above keys are required.

###Usage

```ruby
class Action < SP::Action

  options default_option_for_this_action: 1

end

action = Action.new(option_only_for_this_call: 2).get
```

This will get data from:

```/action.json?option_only_for_this_call=2&default_option_for_this_action=1``` + ```default options from config```

You can override options in following order:
```options from config``` < ```options from class``` < ```options from
instance```
