// Nitrogen Compatibility Layer

function unbase64(base64) {
    var binary_string = window.atob(base64);
    var len = binary_string.length;
    var bytes = new Uint8Array(len);
    for (var i = 0; i < len; i++) bytes[i] = binary_string.charCodeAt(i);
    return bytes.buffer;
}

function direct(term) { ws.send(enc(tuple(atom('direct'),term))); }
function validateSources() { return true; }
function querySourceRaw(Id) {
    var val, el = document.getElementById(Id);
    if (!el) {
       val = qs('input[name='+Id+']:checked'); val = val ? bin(val.value) : bin("");
    } else switch (el.tagName) {
        case 'FIELDSET':
            val = qs('[id="'+Id+'"]:checked'); val = val ? bin(val.value) : bin(""); break;
        case 'INPUT':
            switch (el.getAttribute("type")) {
                case 'radio': case 'checkbox': val = qs('input[name='+Id+']:checked'); val = val ? val.value : ""; break;
                case 'date': val = Date.parse(el.value); val = val && new Date(val) || ""; break;
                case 'text': var x = el.getAttribute('data-bind'); if (x) val=dec(unbase64(x)); break;
                case 'calendar': var x = pickers[el.id]._d; val = tuple(number(x.getFullYear()),number(x.getMonth()+1),number(x.getDate())); break;
                default:
                    var edit = el.contentEditable;
                    if (edit && edit === 'true') val = bin(el.innerHTML);
                    else val = bin(el.value);
            }
            break;
        default:
            if (el.getAttribute('data-vector-input')) {
                val = querySourceRaw(el.children[1].id);
            } else if (el.getAttribute('data-sortable-list')) {
                val = getSortableValues('#' + el.id);
            } else if (el.contentEditable === 'true') {
                val = el.innerHTML;
            } else {
                val = el.value;
                switch (val) {
                    case "true": val = atom('true'); break;
                    case "false": val = atom('false'); break;
                }
            }
    }
    return val;
}

function querySource(Id) {
    var qs = querySourceRaw(Id);
    if (qs && qs.t && qs.v) return qs;
    else if (qs instanceof Array) { return list.apply(null, qs.map(bin)); }
    else { return bin(qs); }
}

