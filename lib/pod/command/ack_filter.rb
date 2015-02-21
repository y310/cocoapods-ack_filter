require 'libxml' # used in CFPropertyList to pretty-print Acknowledgement.plist
require 'CFPropertyList'

module Pod
  class Command
    class AckFilter < Command
      self.summary = 'Filter out licenses with pattern from Pods-acknowledgements.plist'
      self.arguments = [
        CLAide::Argument.new("PATTERN", true)
      ]

      def self.options
        [['--input=FILE_PATH', 'Read acknowledgements file from FILE_PATH'],
         ['--output=FILENAME', 'Output filtered acknowledgements to FILENAME']]
      end

      def self.filter(args, &block)
        self.new(args, &block).run
      end

      def initialize(argv, &block)
        if argv.kind_of?(CLAide::ARGV)
          @pattern = Regexp.new(argv.shift_argument) unless argv.empty?
          @input = argv.option('input')
          @filename = argv.option('output')
          super
        else
          if argv[:pattern]
            @pattern = argv[:pattern].kind_of?(Regexp) ? argv[:pattern] : Regexp.new(argv[:pattern])
          end
          @input = argv[:input]
          @filename = argv[:output]
          @filter_block = block
        end
      end

      def validate!
        super
        help! 'Specify filtering pattern' if !@pattern && !@filter_block
      end

      def input
        @input || 'Pods/Target Support Files/Pods/Pods-acknowledgements.plist'
      end

      def output_filename
        @filename || 'Acknowledgements.plist'
      end

      def run
        plist = CFPropertyList::List.new(file: input)
        specs = plist.value.value['PreferenceSpecifiers']
        specs.value.reject! do |spec|
          if @filter_block
            @filter_block.call(spec.value['FooterText'].value)
          else
            spec.value['FooterText'].value =~ @pattern
          end
        end
        plist.save(output_filename, CFPropertyList::List::FORMAT_XML)
      end
    end
  end
end
