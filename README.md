# Cocoapods::AckFilter

Cocoapods aggregates installed pod's license to Pods/Pods-acknowledgements.plist.
But it also includes private pod's license.
AckFilter filters out such license by arbitrary pattern and re-generate aggretated plist.

## Installation

Add this line to your application's Gemfile:

    gem 'cocoapods-ack_filter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cocoapods-ack_filter

## Usage

```
pod ack-filter PATTERN [--input=FILENAME] [--output=FILENAME] [--filterfile=FILENAME]
```

- PATTERN is regexp pattern string
- --input is input acknowledgements.plist filename
- --output is output filename
- --filterfile is a file containing a regular expression for filtering (e.g. "Pod1|Pod2" filters all occurrences of the string Pod1 and Pod2)

### Example

```
pod ack-filter MyCompany
# => Licenses which includes "MyCompany" are filtered out and output to "Acknowledgements.plist"
```

```
pod ack-filter MyCompany --output=Filtered.plist
# => Licenses which includes "MyCompany" are filtered out and output to "Filtered.plist"
```

```
pod ack-filter --input=unfiltered.plist --output=filtered.plist --filterfile=filterfile
# => Regular expression from "filterfile" is used to filter "unfiltered.plist" and save it to "filtered.plist"
```

Also, you can use ack_filter within Podfile.

```
post_install do
  Pod::Command::AckFilter.filter(pattern: /MyCompany/, output: 'Filtered.plist')
end
```

For complex condition, you can use block to define filter.

```
post_install do
  Pod::Command::AckFilter.filter(output: 'Filtered.plist') do |text|
    text =~ /MyCompany/ && text !~ /Foobar/
  end
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cocoapods-ack_filter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
