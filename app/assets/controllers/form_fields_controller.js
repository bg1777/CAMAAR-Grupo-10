// app/javascript/controllers/form_fields_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  add_field(event) {
    event.preventDefault()
    
    const link = event.currentTarget
    const association = link.dataset.association
    const content = link.dataset.fields
    
    const new_id = new Date().getTime()
    const regexp = new RegExp("new_" + association, "g")
    const new_fields = content.replace(regexp, new_id)
    
    const temp = document.createElement('div')
    temp.innerHTML = new_fields
    this.containerTarget.appendChild(temp.firstElementChild)
  }
}
