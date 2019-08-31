module ValidationPatterns

  ID = /\A[a-zA-Z0-9\-_]{2,100}\z/i
  EMAIL = /\A\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*\z/i

end