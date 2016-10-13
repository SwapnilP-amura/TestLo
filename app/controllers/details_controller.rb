class DetailsController < ApplicationController
    def edit
        @user = User.find(current_user.id)

        if @user.type == 'Student'
            @student = Student.find(current_user.id)
            if @student.student_detail.blank?
                redirect_to new_student_detail_path
            else
                redirect_to edit_student_detail_path(@student.student_detail)
            end

        else
            @employer = Employer.find(current_user.id)
            if @employer.employer_detail.blank?
                redirect_to new_employer_detail_path
            else
                redirect_to edit_employer_detail_path(@employer.employer_detail)
            end
        end
    end
end
