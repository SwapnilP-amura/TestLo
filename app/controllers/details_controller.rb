class DetailsController < ApplicationController
  def edit
      @user=User.find(current_user.id)
      if @user.type=="Student"
            redirect_to edit_student_details_path
      else
            redirect_to edit_employer_details_path
      end
  end
#students
  def edit_student_details
      @student=Student.find(current_user.id)
      if @student.student_detail.nil?
            redirect_to new_student_details_path
      end
  end

  def new_student_details
      @student=Student.find(current_user.id)
  end

  def create_student_details
      @student=Student.find(current_user.id)
      if @student.create_student_detail(student_details_params)
        flash[:success]="Profile Updated Successfully"
        redirect_to student_dashboard_path
      else
        render 'new_student_details'
      end
  end

  def update_student_details
    @student=Student.find(current_user.id)
    if @student.student_detail.update_attributes(student_details_params)
      flash[:success]="Profile Updated Successfully"
      redirect_to student_dashboard_path
    else
      render 'edit_student_details'
    end
  end
  ##Employer
  def edit_employer_details
      @employer=Employer.find(current_user.id)
      if @employer.employer_detail.nil?
            redirect_to new_employer_details_path
            #if doesnt exist to edit redirect to create one
      end
  end

  def new_employer_details
      @employer=Employer.find(current_user.id)
  end

  def create_employer_details
      @employer=Employer.find(current_user.id)
      @detail=@employer.build_employer_detail(employer_details_params)
      if @detail.save
        flash[:success]="Profile Created Successfully"
        redirect_to employer_dashboard_path
      else
        render 'new_employer_details'
      end
  end

  def update_employer_details
    @employer=Employer.find(current_user.id)
    if @employer.employer_detail.update_attributes(employer_details_params)
      flash[:success]="Profile Updated Successfully"
      redirect_to employer_dashboard_path
    else
      render 'edit_employer_details'
    end
  end


  def test
    render plain: "test"
  end

  private
    def student_details_params
      params.require(:student_detail).permit(:age,:college,:resume,:experience,:skills)
    end

    def employer_details_params
      params.require(:employer_detail).permit(:company,:company_address,:contact)
    end
end
