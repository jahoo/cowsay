require_relative './cowsay/version'
require_relative './cowsay/character'

module ::Cowsay
  module_function # all instance methods are available on the module (class) level

  def random_character
    Character.new(character_classes[rand(character_classes.length)])
  end

  def character_classes
    @character_classes ||= Dir.children(''./lib/templates').map { |t| File.basename(t, '.txt') }
  end

  def say(message, template_name)
    if template_name == 'random'
      random_character.say(message)
    elsif character_classes.include? template_name
      Character.new(template_name).say(message)
    else
      puts "No cow file found for #{template_name}. Use the -l flag to see a list of available cow files."
    end
  end
end
