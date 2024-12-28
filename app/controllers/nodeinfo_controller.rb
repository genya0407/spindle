class NodeinfoController < ApplicationController
  def show
    json = {
      openRegistrations: false,
      protocols: [
        "activitypub"
      ],
      software: {
        name: "spindler",
        version: "0.1.0"
      },
      usage: {
        users: {
          total: Group.count
        }
      },
      version: "2.1"
    }
    render json: json
  end
end
