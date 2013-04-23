module ConstructorCap
  class Engine < Rails::Engine
    engine_name "constructor_cap" 
    isolate_namespace ConstructorCap     
  end
end