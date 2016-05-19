class Zendesk2::TicketAudits
  include Zendesk2::Collection

  include Zendesk2::PagedCollection

  model Zendesk2::TicketAudit

  attribute :ticket_id, type: :integer

  self.collection_method = :get_ticket_audits
  self.collection_root   = "audits"
  self.model_method      = :get_ticket_audit
  self.model_root        = "audit"

  def ticket
    self.service.tickets.get(self.ticket_id)
  end

  def all(params={})
    requires :ticket_id

    body = service.send(collection_method, {"ticket_id" => self.ticket_id}.merge(params)).body

    collection = self.clone.load(body[collection_root])
    collection.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
    collection
  end

  def get(id)
    requires :ticket_id

    if data = self.service.send(model_method, {"ticket_id" => self.ticket_id, "id" => id}).body[self.model_root]
      new(data)
    end
  rescue Zendesk2::Error
    nil
  end
end
