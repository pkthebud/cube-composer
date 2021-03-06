module DOMHelper where

import Control.Monad.Eff
import DOM
import Data.DOM.Simple.Document
import Data.DOM.Simple.Element
import Data.DOM.Simple.Types
import Data.Maybe

-- | Get the parent element in the DOM tree, this should be in purescript-simple-dom
foreign import parentElement
    """
    function parentElement(child) {
        return function() {
            return child.parentElement;
        };
    }
    """ :: forall eff. HTMLElement
        -> Eff (dom :: DOM | eff) HTMLElement

-- | Create a new DOM element, this should be in purescript-simple-dom
foreign import createElement
    """
    function createElement(doc) {
        return function(tag) {
            return function() {
                return doc.createElement(tag);
            };
        };
    }
    """ :: forall eff. HTMLDocument
        -> String
        -> Eff (dom :: DOM | eff) HTMLElement

-- | Read the URL hash from a given DOM location
foreign import getLocationHash
    """
    function getLocationHash(loc) {
        return function() {
            if (loc.hash) {
                return loc.hash.substring(1);
            } else {
                return "";
            }
        };
    }
    """ :: forall eff. DOMLocation
        -> Eff (dom :: DOM | eff) String

-- | Perform a DOM action with a single element which can be accessed by ID
withElementById :: forall eff. String
                -> HTMLDocument
                -> (HTMLElement -> Eff (dom :: DOM | eff) Unit)
                -> Eff (dom :: DOM | eff) Unit
withElementById id doc f = getElementById id doc >>= maybe (return unit) f

-- | Add a 'change' event handler to an element
foreign import addChangeEventListener
    """
    function addChangeEventListener(cb) {
        return function(src) {
            return function() {
                src.addEventListener("change", cb(src));
            };
        };
    }
    """ :: forall eff. (HTMLElement -> Eff (dom :: DOM | eff) Unit)
        -> HTMLElement
        -> Eff (dom :: DOM | eff) Unit

foreign import getSelectedValue
    """
    function getSelectedValue(src) {
        return function() {
            return src.options[src.selectedIndex].value;
        };
    }
    """ :: forall eff. HTMLElement
        -> Eff (dom :: DOM | eff) String
