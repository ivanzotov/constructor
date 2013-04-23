module Constructor
  class Engine < Rails::Engine
    engine_name "constructor"
    isolate_namespace Constructor
  end
end