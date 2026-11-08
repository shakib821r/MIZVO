/* MIZVO theme: Light / Dark / System. Loaded in <head> so the right theme shows before the page paints. */
(function () {
  var KEY = "mizvo-theme";
  function getPref() {
    try {
      var v = localStorage.getItem(KEY);
      return v === "light" || v === "dark" || v === "system" ? v : "system";
    } catch (e) { return "system"; }
  }
  function apply(pref) {
    var dark = pref === "dark" ||
      (pref === "system" && window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches);
    document.documentElement.setAttribute("data-theme", dark ? "dark" : "light");
  }
  function setPref(pref) {
    try { localStorage.setItem(KEY, pref); } catch (e) {}
    apply(pref);
  }
  apply(getPref());
  if (window.matchMedia) {
    var mq = window.matchMedia("(prefers-color-scheme: dark)");
    var onChange = function () { if (getPref() === "system") apply("system"); };
    if (mq.addEventListener) { mq.addEventListener("change", onChange); }
    else if (mq.addListener) { mq.addListener(onChange); }
  }
  window.MizvoTheme = { get: getPref, set: setPref };
})();
