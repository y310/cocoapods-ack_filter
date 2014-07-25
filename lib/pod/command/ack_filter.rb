require 'CFPropertyList'

module Pod
  class Command
    class AckFilter < Command
      ACKNOWLEDGEMENTS_FILE = 'Pods/Pods-acknowledgements.plist'

      self.summary = 'Filter out licenses with pattern from Pods-acknowledgements.plist'
      self.arguments = [['PATTERN', :required]]

      def self.options
        [['--output=FILENAME', 'Output filtered acknowledgements to FILENAME']]
      end

      def self.filter(pattern, filename = nil)
        args = [pattern]
        args << "--output=#{filename}" if filename
        self.new(CLAide::ARGV.new(args)).run
      end

      def initialize(argv)
        @pattern = argv.shift_argument
        @filename = argv.option('output')
        super
      end

      def validate!
        super
        help! 'Specify filtering pattern' unless @pattern
      end

      def output_filename
        @filename || 'Acknowledgements.plist'
      end

      def run
        plist = CFPropertyList::List.new(file: ACKNOWLEDGEMENTS_FILE)
        specs = plist.value.value['PreferenceSpecifiers']
        specs.value.reject! do |spec|
          spec.value['FooterText'].value =~ /#{@pattern}/
        end
        plist.save(output_filename, CFPropertyList::List::FORMAT_XML)
      end
    end
  end
end
