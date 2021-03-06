class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :get_team

  def get_team
    @team = Team.find(params[:team_id])
  end

  # GET /events
  # GET /events.json
  def index
    if params[:team_id].nil?
      @events = Event.all
    else
      @events = @team.events
    end

  end

  # GET /events/1
  # GET /events/1.json
  def show
    @events = Event.all
    if params[:status]
      @event.update_attributes(status: true)
      current_user.person.events <<  @event
    end
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.team = @team
    @events = Event.all
  end

  # GET /events/1/edit
  def edit
    @events = Event.all
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    if current_user.person.turma
      if current_user.person.turma == @team
        @event.status = true
      end
    end
  
    @event.autor_id = current_user.id
    current_user.person.events <<  @event

    respond_to do |format|
      if @event.save
        format.html { redirect_to [@team,@event], notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update

    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to [@team,@event], notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to team_url(@team), notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params_status
      params.require(:event).permit(:status)
    end

    def event_params
      params.require(:event).permit(:team_id, :inicio, :fim, :local, :descricao)
    end
end
