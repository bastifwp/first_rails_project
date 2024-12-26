class FriendsController < ApplicationController

  #El before action hace algo antes de todas las cosas de abajo (antes de un get, antes de un update, etc)
  before_action :set_friend, only: %i[ show edit update destroy ]

  #Sería bueno autenticar al usuario antes de hacer cualquier cosa
  before_action :authenticate_user!, except: [:index, :show] #En caso q no este autenticado, no puede hacer nada exepto ver el index y el show

  #Solo el usuario que creó el friend puede editarlo, actualizarlo o borrarlo
  before_action :correct_user, only: [:edit, :update, :destroy, :show] #Solo el usuario que creó el friend puede editarlo, actualizarlo o borrarlo 


  # GET /friends or /friends.json
  def index
    @friends = Friend.all #Hace consula a la base de datos y @friends es accesible desde la vista html
    

    #Si tuviera la siguiente variable: @prueba = "Hola mundo"
    #Desde la vista friends_controller/index.html.erb puedo acceder a la variable @prueba
    #usando <%= @prueba %>
  end

  # GET /friends/1 or /friends/1.json
  def show
  end

  # GET /friends/new  Creoq  este método es pa mostrar la página
  def new 
    #@friend = Friend.new
    @friend = current_user.friends.build #Con este se asocia a los amigos del current user
  end

  # GET /friends/1/edit
  def edit
  end

  # POST /friends or /friends.json
  def create
    #@friend = Friend.new(friend_params)
    @friend = current_user.friends.build(friend_params) 

    respond_to do |format|
      if @friend.save
        format.html { redirect_to @friend, notice: "Friend was successfully created." }
        format.json { render :show, status: :created, location: @friend }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /friends/1 or /friends/1.json
  def update
    respond_to do |format|
      if @friend.update(friend_params)
        format.html { redirect_to @friend, notice: "Friend was successfully updated." }
        format.json { render :show, status: :ok, location: @friend }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friends/1 or /friends/1.json
  def destroy
    @friend.destroy!

    respond_to do |format|
      format.html { redirect_to friends_path, status: :see_other, notice: "Friend was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def correct_user

    #Buscamos el id que le entrego la gema devise
    @friend = current_user.friends.find_by(id: params[:id])
    
    #Si está incorrecto:
    redirect_to friends_path, notice: "Not authorized to see this friend perkin" if @friend.nil?

  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friend
      @friend = Friend.find(params.expect(:id))
    end

    #Params are form fields, permite entrar a la base de datos si cumple con estos parametros
    # Only allow a list of trusted parameters through.
    def friend_params
      params.expect(friend: [ :first_name, :last_name, :email, :phone, :twitter, :user_id ])
    end
end
