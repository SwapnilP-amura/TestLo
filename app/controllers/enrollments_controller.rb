class EnrollmentsController < ApplicationController
  include EnrollmentsHelper
  before_action :check_user
  before_action :check_student_profile,only:[:enroll_for_test,:taketest]
  before_action :get_test_by_id,only:[:enroll_for_test,:taketest,:show_current_question,:submit_clicked,:finish]
  before_action :get_enrollment,only:[:taketest,:submit_clicked,:finish]
  before_action :check_test_time,only:[:taketest,:submit_clicked]

  def taketest
    #check_student_profile
    #get_test_by_id
    #get_enrollment(also check enrolled or not)
    #check_time
    join_data
    @enrollment.record_start_time
    @now=@enrollment.get_start_time
  end

  def show_current_question
    #get_test_by_id
    @current_question = Question.get_question_by_id(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def submit_clicked
    #filter get_test_by_id
    #filter get_enrollment
    #filter time
    @question_id=params[:question][:id]
    @response=params[:response]
    @enrollment.save_response_for_question(@response,@question_id)
    join_data
    @now=@enrollment.get_start_time
    respond_to do |format|
      format.js
    end
  end

  def enroll_for_test
    #check_profile _complete
    @user=current_user
    @tests = Test.all.page(params[:page])
    Enrollment.enroll_user_for_test(@current_test,current_user)
    @enrolled_test= Enrollment.tests_enrolled_by_user(current_user).pluck(:test_id)
    respond_to do |format|
      format.js
    end
  end

  def finish
    #filter get_test_by_id
    #filter-get_enrollement
    @score=@enrollment.submit_test
    #for view
    @total_marks=@current_test.marks
    @total_noq=TestQuestion.get_test_questions_join(@current_test.id).size
    @attempted=@enrollment.response.count
    @percentage=(@score/@total_marks.to_f).round(4)*100
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def get_enrollment
    @enrollment=Enrollment.get_enrollment_for_test(@current_test,current_user)
    if @enrollment.nil?
      flash[:danger]="Enroll First"
      if request.xhr?
        render :js=> "window.location = #{student_dashboard_path.to_json}"
      else
        redirect_to student_dashboard_path
      end
    end
  end

  def get_test_by_id
    @current_test = Test.get_test_by_id(params[:test_id])
    if @current_test.nil?
      flash[:danger]="Test doesnt exist"
      if request.xhr?
        render :js=> "window.location = #{student_dashboard_path.to_json}"
      else
        redirect_to student_dashboard_path
      end
    end
  end

  def check_user
      unless current_user.type=="Student"
        flash[:danger]="Authorizaion Error"
        if request.xhr?
          render :js=> "window.location = #{error_path.to_json}"
        else
          redirect_to error_path
        end
      end
  end

  def check_student_profile
      if current_user.student_detail.nil?
          if request.xhr?
            flash[:danger]= 'Complete profile first'
            render :js => "window.location = #{new_student_details_path.to_json}"
          else
            flash[:danger]= 'Complete profile first'
            redirect_to new_student_details_path
          end
      end
  end

  def check_test_time
    unless @enrollment.start_time.nil?
      #if user is trying to take test more than once
      if Time.now.utc > @enrollment.start_time.plus_with_duration(get_total_seconds(@current_test.duration))
        flash[:danger]="Time is over"
        #if not attempted and time is over ,call finish action
        unless @enrollment.attempted
          if request.xhr?
            render :js => "window.location = #{finish_path.to_json}"
          else
            redirect_to finish_path
          end
        else
          if request.xhr?
            render :js => "window.location = #{student_dashboard_path.to_json}"
          else
            redirect_to student_dashboard_path
          end
        end
      end
    end
  end

  def join_data
    #all questions in test
    @test_questions=TestQuestion.get_questions_of_test(@current_test)
    #filter attempted
    @unattempted=@test_questions.select{|t| question_attempted(t.question.id,@current_test.id)==false}
    #current_question is always first unqttempted
    unless @unattempted.empty?
      #select first question from unattempted list
      @current_question = @unattempted.first.question
      #get unattempted sorted by question ids
    else
      #if all are attempted then select first question from list
      #unqttempted will be empty
      @current_question=@test_questions.first.question
    end
  end
end
