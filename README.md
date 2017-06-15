# Nkrb
Nkrb is a ruby library included very useful methods.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nkrb'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install nkrb

## Methods
#### 1. read_file
```
filename = "./text.txt"
texts = Nkrb.read_file(filename)
p texts

## => 
## [
##  'Hello world',
##  "I'm your father."
## ]
```
text.txt
```
Hello world.
I'm your father.
```

#### 2. read_tsv
```
filename = "./data.tsv"
data = Nkrb.read_tsv(filename)
p data

## => 
## [
##  {"id": "1", "name": "satoh"},
##  {"id": "2", "name": "suzuki"},
##  {"id": "3", "name": "takahashi"},
## ]
```

data.tsv
```
id\tname
1\tsatoh
2\tsuzuki
3\ttakahashi
```

#### 3. pluck

```
collection = [
 {id: "1", name: "satoh"},
 {id: "2", name: "suzuki"},
 {id: "3", name: "takahashi"},
]
p Nkrb.pluck(collection, key: :name)
## => 
## [
##  "satoh", "suzuki", "takahashi"
## ]
```

#### 4. download_image

```
image_url = "https://cdn.pixabay.com/photo/2017/05/15/17/43/calm-2315559_960_720.jpg"
dist_dir = "/tmp/"
filename = "nkrb_test_img"
Nkrb.download_image(image_url, dist_dir, filename)

## ls /tmp/nkrb_test_img.jpg
## => /tmp/nkrb_test_img.jpg
```


#### 5. faraday_connection

```
url = "http://sushi.com"
connection = Nkrb.faraday_connection(url)
res = connection.get do |req|
  req.url '/search', :page => 2
  req.params['limit'] = 100
end
p res.body
```

#### 6. nokogiri

```
url = "https://www.youtube.com/?hl=ja&gl=JP"
doc = Nkrb.nokogiri(url)
p doc
```


#### 7. random_str
```
p Nkrb.random_str(10)
# => "2vjAkcdB34" 
```

#### 8. remove_ctr
```
ctr_str = "\n\nhello\t"
p Nkrb.remove_ctr(ctr_str, replace: "")
# => "  hello "
```

#### 9.output_tsv
```
collection = [
  {key1: "a1", key2: "a2"},
  {key1: "a3", key2: "a4"},
]

Nkrb.output_tsv(collection, delimiter: "\t", required_header: true)
# => 
# key1\tkey2
# a1\ta2
# a3\ta4
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nkrb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

