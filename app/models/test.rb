class Test < ActiveRecord::Base
    # with questions
    has_many :test_questions, dependent: :destroy
    has_many :questions, through: :test_questions

    # with Employer
    belongs_to :employer

    # with student
    has_many :enrollments, dependent: :destroy
    has_many :students, through: :enrollments

    # validaions
    # testname validation
    validates :name,
              uniqueness: true,
              presence:   true

    # date validation
    validate :test_date_cannot_be_in_the_past

    # duration validation
    validates :duration,
              presence: true

    validate :duration_greater_than_zero

    validates :marks,
              numericality: true

    validates :number_of_questions,
              numericality: true

    validates :private, inclusion: { in: [true, false] }
    validates :active, inclusion: { in: [true, false] }
    # Validation Methods

    def duration_greater_than_zero
        if duration.seconds_since_midnight.zero?
            errors.add(:duration, "can't be zero")
        end
    end

    def test_date_cannot_be_in_the_past
        if date.present? && date < DateTime.now.utc.to_date
            errors.add(:date, "can't be in the past")
        end
    end

    # Instance Methods
    def add_question_with_marks!(marks)
      self.change_number_of_questions(1)
      self.change_marks(marks)
      save
    end

    def remove_question_with_marks!(marks)
      self.change_number_of_questions(-1)
      self.change_marks(-marks)
      save
    end

    def change_number_of_questions(number)
        self.number_of_questions += number
    end

    def change_marks(marks)
        self.marks += marks
    end

    def change_privacy!
        toggle(:private)
        save
    end

    def change_activity!
        toggle(:active)
        save
    end

    # Class Methods
    def self.employer_test_which_are(current_user, query_type)
        case query_type
        when 'active'
            self.where(employer_id: current_user.id, active: true)
        when 'inactive'
            self.where(employer_id: current_user.id, active: false)
        when 'public'
            self.where.not(employer_id: current_user.id).where(active: true, private: false)
        else
            self.where(employer_id: current_user.id)
        end
    end

    def self.student_test_which_are_enrolled(current_user, query_type, enrolled_test, page_no)
        case query_type
        when 'enrolled'
            self.where(active: true, id: enrolled_test).where('date >= ?', Date.today).page(page_no)
        when 'not enrolled'
            # not enrolled and not expired yet
            self.where.not(id: enrolled_test).where(active: true).where('date >= ?', Date.today).page(page_no)
        when 'expired'
            self.where.not(id: enrolled_test).where(active: true).where('date < ?', Date.today).page(page_no)
        when 'attempted'
            enrolled_test_for_attempted = Enrollment.all.where(student_id: current_user.id, attempted: true).pluck(:test_id)
            self.where(id: enrolled_test_for_attempted).page(page_no)
        else
            self.where(active: true).page(page_no)
        end
    end

    def self.get_test_by_id(test_id)
        find(test_id)
    end
end
