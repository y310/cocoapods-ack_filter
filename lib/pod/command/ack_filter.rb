require 'CFPropertyList'

module Pod
  class Command
    class AckFilter < Command
      ACKNOWLEDGEMENTS_FILE = 'Pods/Target Support Files/Pods/Pods-acknowledgements.plist'

      self.summary = 'Filter out licenses with pattern from Pods-acknowledgements.plist'
      self.arguments = [
        CLAide::Argument.new("PATTERN", true)
      ]

      def self.options
        [['--output=FILENAME', 'Output filtered acknowledgements to FILENAME']]
      end

      def self.filter(args, &block)
        self.new(args, &block).run
      end

      def initialize(argv, &block)
        if argv.kind_of?(CLAide::ARGV)
          @pattern = Regexp.new(argv.shift_argument) unless argv.empty?
          @filename = argv.option('output')
          super
        else
          if argv[:pattern]
            @pattern = argv[:pattern].kind_of?(Regexp) ? argv[:pattern] : Regexp.new(argv[:pattern])
          end
          @filename = argv[:output]
          @filter_block = block
        end
      end

      def validate!
        super
        help! 'Specify filtering pattern' if !@pattern && !@filter_block
      end

      def output_filename
        @filename || 'Acknowledgements.plist'
      end

      def run
        plist = CFPropertyList::List.new(file: ACKNOWLEDGEMENTS_FILE)
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
