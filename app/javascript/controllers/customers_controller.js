import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["search", "count", "card", "pageNumber", "previous", "next"]
  static values = { pageSize: Number }

  connect() {
    this.page = 0
    this.render()
  }

  search() {
    this.page = 0
    this.render()
  }

  previous() {
    if (this.page > 0) {
      this.page -= 1
      this.render()
    }
  }

  next() {
    const totalPages = Math.max(1, Math.ceil(this.filteredCards.length / this.pageSizeValue))

    if (this.page < totalPages - 1) {
      this.page += 1
      this.render()
    }
  }

  render() {
    const matches = this.filteredCards
    const totalPages = Math.max(1, Math.ceil(matches.length / this.pageSizeValue))

    this.page = Math.min(this.page, totalPages - 1)

    this.cardTargets.forEach((card) => {
      card.hidden = true
    })

    matches
      .slice(this.page * this.pageSizeValue, (this.page + 1) * this.pageSizeValue)
      .forEach((card) => {
        card.hidden = false
      })

    this.countTarget.textContent = `${matches.length} ${matches.length === 1 ? "customer" : "customers"}`
    this.pageNumberTarget.textContent = `Page ${this.page + 1} of ${totalPages}`
    this.previousTarget.disabled = this.page === 0
    this.nextTarget.disabled = this.page >= totalPages - 1
  }

  get filteredCards() {
    const term = this.searchTarget.value.trim().toLowerCase()

    return this.cardTargets.filter((card) => card.dataset.search.includes(term))
  }
}
