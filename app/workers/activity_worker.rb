class ActivityWorker
  include Sidekiq::Worker

  def perform(resource, resource_id, user_id, options = {})
	record = resource.safe_constantize.find(resource_id)
	user = User.find(user_id)

  	if options["key"] == nil && options["action"] == nil
	  	record.create_activity :create, owner: user
	else
		record.create_activity key: options["key"], action: options["action"], owner: user
	end
  end
end