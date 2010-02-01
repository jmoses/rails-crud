module CRUD
  module Base
    def self.included(base)
      base.send :include, ClassMethods
    end

    module ClassMethods
      def self.included(base)
        base.send :before_filter, :build_object, :only => [:new, :create]
        base.send :before_filter, :load_object, :only => [:edit, :update, :destroy]
        base.send :before_filter, :load_collection, :only => :index

        base.send :helper_method, :base_name, :model, :get_model_variable, :get_collection_variable, :header_for_column,
          :content_columns, :value_for_column
        
      end
    end
    
    def index;
       crud_render
    end
    def new; 
      crud_render
    end
    def edit
      crud_render
    end
    
    def create
      if get_model_variable.save
        redirect_to :action => :index and return
      else
        crud_render :new
      end
    end
    
    def update
      get_model_variable.attributes = params[param_key]
      if get_model_variable.save
        redirect_to :action => :index and return
      else
        crud_render :edit
      end
    end
    
    def destroy
      if get_model_variable.destroy
        redirect_to :action => :index and return
      else
        crud_render :index
      end
    end

    protected
      def content_columns
        [
          [:to_s, "Object"]
        ]
      end
      
      def header_for_column( col )
        col[1] or col[0].to_s.humanize.titleize
      end
      
      def value_for_column( object, col )
        case ( thing = col.first)
        when Symbol
          object.send thing
        when Proc
          thing.call( object )
        else
          thing
        end
      end
    
      def build_object
        set_model_variable model.new( params[param_key] )
      end
    
      def load_object
        set_model_variable model.find( params[:id] )
      end
      
      def load_collection
        set_collection_variable model.paginate :page => params[:page], :order => collection_order
      end
      
      def collection_order
        "created_at asc"
      end
      
      def set_collection_variable( obj )
        instance_variable_set("@#{base_name.pluralize}", obj)
      end
      
      def get_collection_variable
        instance_variable_get("@#{base_name.pluralize}")
      end
    
      def base_name
        @base_name ||= controller_name.singularize      
      end
    
      def param_key
        base_name.to_sym
      end
    
      def model_variable
        "@#{base_name}"
      end
    
      def set_model_variable( obj )
        instance_variable_set(model_variable, obj)
      end
    
      def get_model_variable
        instance_variable_get(model_variable)
      end
    
      def model
        base_name.classify.constantize
      end
      
      def crud_render( template = action_name )
        begin
          render template
        rescue ActionView::MissingTemplate
          render :template => "crud/#{template}"
        end
      end
  end
end