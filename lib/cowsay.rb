require 'cowsay/version'
require 'cowsay/character'

module ::Cowsay
  module_function # all instance methods are available on the module (class) level

  def random_character
    Character.new(character_classes[rand(character_classes.length)])
  end

  def character_classes
    @character_classes ||= begin
      templates_path = ENV['COWSAY_TEMPLATES_PATH'] || [Gem.loaded_specs['cowsay'].full_gem_path, '/lib/templates'].join('')
      Dir.children(templates_path).map { |t| File.basename(t, '.txt') }
    end
  end

  def say(message, template_name)
    template_name ||= 'pika'

    if template_name == 'random'
      random_character.say(message)
    elsif character_classes.include? template_name
      Character.new(template_name).say(message)
    else
      puts "No cow file found for #{template_name}. Use the -l flag to see a list of available cow files."
    end
  end
end
