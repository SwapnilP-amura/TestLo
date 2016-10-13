class Question < ActiveRecord::Base
    attr_accessor :a, :b, :c, :d

    # This works
    [:correct_answer, :options].each do |t|
        serialize t, Array
    end

    # with test
    has_many :test_questions, dependent: :destroy
    has_many :tests, through: :test_questions

    # with category
    belongs_to :category

    belongs_to :employer
    # validations
    validates :question,
              presence: true

    validates :question_type,
              presence: true,
              numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2 }

    # options
    validate :option_map_for_different_question_type

    # correct_answers
    validate :correct_answers_map_for_different_question_type

    def option_map_for_different_question_type
        case question_type
        when 0
            if options.any? { |x| !x.blank? }
                errors.add(:options, 'Options not allowed for integer type')
            end
        when 1
            errors.add(:options, 'Needs all options') if options.all?(&:blank?)
        when 2
            errors.add(:options, 'Needs all option') if options.all?(&:blank?)
          end
    end

    def correct_answers_map_for_different_question_type
        case question_type
        when 0
            if correct_answer[0].blank?
                errors.add(:correct_answer, 'Need answer for integer type')
            end
        when 1
            if no_of_answer != 1
                errors.add(:correct_answer, 'Incorrect  number of answer')
            end
        when 2
            if no_of_answer < 2
                errors.add(:correct_answer, 'Incorrect  number of answer')
            end
        end
    end

    def no_of_answer
        number = 0
        correct_answer.each do |x|
            number += 1 unless x.blank?
        end
        number
    end

    # instance methods

    # class methods
    def self.get_questions_excluding(test_question_ids)
        self.where.not(id: test_question_ids)
    end

    def self.get_question_by_id(id)
        self.find(id)
    end
end
