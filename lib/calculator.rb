require "./lib/calculator/version"
require 'pry'

module Calculator
  class CLI
    def begin
      start_input_cursor
      return if @input.chomp[0] == 'q' # quit if first element is 'q'
      if passes_input_validation?(@input)
        str = @input.chomp.split(" ") # splits into array, rejects blanks
        if str.size > 3
          count_operators str
        else
          evaluate_string str
        end
      else
        puts "Input must be a string. Try again once more, please."
        start_input_cursor # fail ArgumentError, 'Input must be a string'
      end
    end

    def is_integer? value
      value.to_s =~ /\A[-+]?\d*\.?\d+\z/
    end

    def start_input_cursor
      puts "Calculator 1.0 \nEnter 'q' to quit."
      print ">> "
      @input = gets
    end

    def passes_input_validation?(input)
      # remove operators
      subject = input.chomp.split(" ")
      if subject.size > 1
        (subject - %w(+ - * / % ^)).
         map { |char| char.respond_to?(:strip) && is_integer?(char) }.any?
      else
        puts "Whoops. Please ensure that you put space before and after operators.
        \nLike so: 200 + 90 \nTry again once more, please."
        start_input_cursor
      end
    end

    def evaluate_with_pemdas str
      begin
        # pemdas_hash{key: weight}
        pemdas_hash = {
          '(' => 1,
          ')' => 1,
          '^' => 2,
          '*' => 3,
          '/' => 4,
          '+' => 5,
          '-' => 6
        }
        # [3, 1]
        index_array  = pemdas_hash.keys.map { |key| str.index(key) }.compact
        answer_array = []
        original_str = str.dup

        if index_array.count > 2 # there are more than two operators
          op_array              = index_array.map{ |i| str[i] }
          order_by_weight_array = []

          op_array.each do |operator| # determine the order of operations by weight
            order_by_weight_array << pemdas_hash[operator]
          end
          order_by_weight_array = order_by_weight_array.sort
          ##
          # start math via order_by_weight_array
          ##

          order_by_weight_array.each do |weight| # find the operator in str & do first maths
            operator       = pemdas_hash.find{ |k, v| v == weight }[0]
            operator_index = str.index(operator)
            fun_array      = []
            fun_array.push str.delete_at( str.index(str[operator_index - 1]) ) # left_operand
            fun_array.push str.delete_at( str.find_index { |el| el == operator } + 1 ) # right_operand

            new_nums = []
            fun_array.each do |n|
              alpha_n = n.match(/^\S*\.\S*$/) ? n.to_f : n.to_i
              new_nums << alpha_n
            end
            answer_array << new_nums.reduce(operator.to_sym)
            str.delete_at(str.find_index { |el| el == operator })

            if str.reject{ |el| %w(+ - * / % ^).include? el }.empty? # there were only operators in here
              real_answer = answer_array.reduce(str[0].to_sym)
              p real_answer and return
            end
          end

          ##
          # end math via order_by_weight_array
          ##
        else # there are only two operators
          index_array.each do |index|
            operator = str[index] ? str[index] : original_str[index]
            if operator
              fun_array     = []
              fun_array.push str.delete_at( str.index(str[index_array[0] - 1]) ) unless %w(+ - * / % ^).include? str[index_array[0] - 1] # left_operand unless its an operator
            end

            if str.uniq.count <= 3 # check str array to make sure we're down to the last operation
              fun_array.clear if fun_array
              answer_array.unshift str.find { |el| el != operator } unless operator
              new_nums = []

              str.reject{ |el| %w(+ - * / % ^).include? el }.each do |n|
                alpha_n = n.to_s.match(/^\S*\.\S*$/) ? n.to_f : n.to_i
                new_nums << alpha_n
              end

              real_answer = (new_nums + answer_array).reduce(operator.to_sym)
              p real_answer
            else
              fun_array.push str.delete_at( str.find_index { |el| el == operator } + 1 ) # right_operand
              new_nums = []
              fun_array.each do |n|
                alpha_n = n.match(/^\S*\.\S*$/) ? n.to_f : n.to_i
                new_nums << alpha_n
              end
              answer_array << new_nums.reduce(operator.to_sym)
            end
          end
        end
      rescue Exception => e
        puts "Whoops." + " " + e.message + " " + "Try again once more, please. Failed inside of #evaluate_with_pemdas"
        start_input_cursor
      end
    end

    def count_operators str
      begin
        op = str & %w(+ - * / % ^).uniq
        if op.count == 1 # all_operators_identical?
          nums     = (str - %w(+ - * / % ^))
          new_nums = []
          nums.each do |n|
            alpha_n = n.match(/^\S*\.\S*$/) ? n.to_f : n.to_i
            new_nums << alpha_n
          end
          popped_op = op.pop
          answer    = new_nums.reduce(popped_op.to_sym)
          p answer
        else # operators_differ?
          evaluate_with_pemdas str
        end
      rescue Exception => e
        puts "Whoops." + " " + e.message + " " + "Try once more, please."
        start_input_cursor
      end
    end

    def evaluate_string str
      begin
        # Float or naw?
        operand1 = str[0].match(/^\S*\.\S*$/) ? str[0].to_f : str[0].to_i
        operand2 = str[2].match(/^\S*\.\S*$/) ? str[2].to_f : str[2].to_i
        operator = str[1].to_sym

        case operator
        when :+ then p operand1 + operand2
        when :- then p operand1 - operand2
        when :* then p operand1 * operand2
        when :/ then p operand1 / operand2
        when :% then p operand1 % operand2
        else
          puts "Invalid input. We could not find an operator. Try again once more, please."
          start_input_cursor
        end
      rescue Exception => e
        if str.size == 1
          passes_input_validation?(str[0])
        else
        puts "Input must be a string. Try again once more, please."
        start_input_cursor
        end
      end
    end

  end
end
