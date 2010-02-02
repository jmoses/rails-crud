module CRUD
  module CrudHelper
    def default_form_for( object )
      crud_partial "form", :object => object
    end
    
    def crud_fields( form )
      crud_partial "fields", :form => form
    end
    
    def crud_partial( partial, locals = {} )
      begin
        render :partial => partial, :locals => locals
      rescue ActionView::MissingTemplate
        render :partial => "crud/#{partial}", :locals => locals
      end
    end
    
    def other_actions( object )
      crud_partial "other_actions", :object => object
    end
  end
end