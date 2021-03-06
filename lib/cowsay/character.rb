module Cowsay
  class Character
    MAX_LINE_LENGTH = 36 unless defined?(MAX_LINE_LENGTH)

    def self.say(message)
      new(template_name).say(message)
    end

    def initialize(template_name = 'pika')
      @template_name = template_name
    end

    def say(message)
      render_balloon(message) + render_character
    end

    def template
      raise '#template should be subclassed'
    end

    private

    def render_character
      templates_path = ENV['COWSAY_TEMPLATES_PATH'] || [Gem.loaded_specs['cowsay'].full_gem_path, '/lib/templates'].join('')
      File.read("#{templates_path}/#{@template_name}.txt")
    end

    def render_balloon(message)
      message_lines = format_message(message)
      line_length = message_lines.max{ |a,b| a.length <=> b.length }.length

      output_lines = []

      output_lines << " #{'_' * (line_length + 2)} "

      message_lines.each do |line|
        # 'Here is your message: %s' % 'hello world'
        # is the same as
        # printf('Here is your message: %s', 'hello world')
        output_lines << "| %-#{line_length}s |" % line
      end

      output_lines << " #{'-' * (line_length + 2)} "
      output_lines << ''

      output_lines.join("\n")
    end

    def format_message(message)
      return [message] if message.length <= MAX_LINE_LENGTH

      lines = []
      words = message.split(/\s/).reject{ |word| word.length.zero? }
      new_line = ''

      words.each do |word|
        new_line << "#{word} "

        if new_line.length > MAX_LINE_LENGTH
          lines << new_line.chomp
          new_line = ''
        end
      end

      lines << new_line.chomp unless new_line.length.zero?

      lines
    end
  end
end
