# frozen_string_literal: true

module LedgerHelper
  def sort_by_date(list)
    # sorting the list by date first and then type
    list&.sort_by { |item| [item['date'], item['type']] }
  end
  
  def unique_list_for_duplicated_ledgers(list)
    # finding the unique transaction as per activity id
    list&.uniq { |ledger| ledger["activity_id"] }
  end

  def build_description(ledger)
    # building the description for a transaction
    "#{ledger["type"]} from #{ledger["source"]["description"] || not_found} for your investment in #{ledger["destination"]["description"] || not_found}"
  end

  def not_found
    # used anonymous if the description is not present
    "Anonymous"
  end
end