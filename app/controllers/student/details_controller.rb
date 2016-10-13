class Student::DetailsController < ApplicationController
    def edit
        @student = Student.find(current_user.id)
        @student_detail = @student.student_detail
    end

    def new
        @student = Student.find(current_user.id)
        @student_detail = @student.build_student_detail
    end

    def create
        @student = Student.find(current_user.id)
        if @student.create_student_detail(student_details_params)
            flash[:success] = 'Profile Updated Successfully'
            redirect_to student_dashboard_path
        else
            render 'new'
        end
    end

    def update
        @student = Student.find(current_user.id)
        if @student.student_detail.update_attributes(student_details_params)
            flash[:success] = 'Profile Updated Successfully'
            redirect_to student_dashboard_path
        else
            render 'edit'
        end
    end

    private

    def student_details_params
        params.require(:student_detail).permit(:age, :college, :resume, :experience, :skills)
    end
end
