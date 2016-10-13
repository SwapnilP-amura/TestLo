class TestQuestion < ActiveRecord::Base
    belongs_to :test
    belongs_to :question

    after_save :add_to_test
    after_destroy :remove_from_test

    # marks validation
    validates :marks,
              numericality: { only_integer: true }

    validates :test_id,
              presence: true

    validates :question_id,
              presence: true

    # class methods
    def self.get_questions_of_test(test)
        TestQuestion.where(test_id: test.id).joins(:question).select('test_questions.*,questions.*')
    end

    def self.create_test_question(test_id, question_id, marks)
        TestQuestion.create(test_id: test_id, question_id: question_id, marks: marks)
    end

    def self.remove_test_question(test_id, question_id)
        test_question = TestQuestion.find_by(test_id: test_id, question_id: question_id)
        test_question.destroy
    end

    def self.get_test_questions_join(test_id)
        TestQuestion.where(test_id: test_id).joins(:question).select('test_questions.*,questions.*')
    end

    private

    def add_to_test
        @test = Test.find(test_id)
        @test.change_marks(marks)
        @test.change_number_of_questions(1)
        @test.save
    end

    def remove_from_test
        @test = Test.find(test_id)
        @test.change_marks(-marks)
        @test.change_number_of_questions(-1)
        @test.save
    end
end
