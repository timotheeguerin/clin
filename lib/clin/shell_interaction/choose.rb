require 'clin'
require 'clin/text'

# Handle a choose question
class Clin::ShellInteraction::Choose < Clin::ShellInteraction
  def run(statement, choices, default: nil, allow_initials: false)
    choices = convert_choices(choices)
    question = prepare_question(statement, choices, default: default, initials: allow_initials)
    loop do
      answer = @shell.ask(question, default: default, autocomplete: choices.keys)
      unless answer.nil?
        choices.each do |choice, _|
          if choice.casecmp(answer) == 0 || (allow_initials && choice[0].casecmp(answer[0]) == 0)
            return choice
          end
        end
      end
      print_choices_help(choices, allow_initials: allow_initials)
    end
  end

  protected def choice_message(choices, default: nil, initials: false)
    choices = choices.keys.map { |x| x == default ? x.to_s.upcase : x }
    msg = if initials
            choices.map { |x| x[0] }.join('')
          else
            choices.join(',')
          end
    "[#{msg}]"
  end

  protected def prepare_question(statement, choices, default: nil, initials: false)
    "#{statement} #{choice_message(choices, default: default, initials: initials)}"
  end

  # Convert the choices to a hash with key being the choice and value the description
  protected def convert_choices(choices)
    if choices.is_a? Array
      Hash[*choices.map { |k| [k, ''] }.flatten]
    elsif choices.is_a? Hash
      choices
    end
  end

  # Print help
  protected def print_choices_help(choices, allow_initials: false)
    puts choice_help(choices, allow_initals: allow_initials)
  end

  def choice_help(choices, allow_initials: false)
    used_initials = Set.new
    Clin::Text.new do |t|
      t.line 'Choose from:'
      choices.each do |choice, description|
        suf = choice.to_s
        suf += ", #{description}" unless description.blank?
        line = if !allow_initials
                 suf
               elsif used_initials.add?(choice[0])
                 "#{choice[0]} - #{suf}"
               else
                 "    #{suf}"
               end
        t.line line, indent: 2
      end
    end
  end
end
