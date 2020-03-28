# shellcheck shell=sh

Include ./echo.sh

Describe 'puts()'
  It 'does not output anything without arguments'
    When call puts
    The entire stdout should equal ''
  End

  It 'outputs arguments'
    When call puts 'a'
    The entire stdout should equal 'a'
  End

  It 'joins arguments with space and outputs'
    When call puts 'a' 'b'
    The entire stdout should equal 'a b'
  End

  It 'outputs with raw string'
    When call puts 'a\b'
    The entire stdout should equal 'a\b'
    The length of entire stdout should equal 3
  End

  It 'outputs "-n"'
    When call puts -n
    The entire stdout should equal '-n'
  End

  Context 'when change IFS'
    Before 'IFS=@'
    It 'joins arguments with spaces'
      When call puts a b c
      The entire stdout should equal 'a b c'
    End
  End
End

Describe 'putsn()'
  It 'does not output anything without arguments'
    When call putsn
    The entire stdout should equal "$LF"
  End

  It 'outputs append with LF'
    When call putsn "a"
    The entire stdout should equal "a$LF"
  End

  It 'joins arguments with space and outputs append with LF'
    When call putsn "a" "b"
    The entire stdout should equal "a b$LF"
  End

  It 'outputs with raw string append with LF'
    When call putsn 'a\b'
    The entire stdout should equal "a\\b$LF"
    The length of entire stdout should equal 4
  End

  Context 'when change IFS'
    It 'joins arguments with spaces'
      BeforeRun 'IFS=@'
      When run putsn a b c
      The entire stdout should equal "a b c$LF"
    End
  End
End

Describe 'echo()'
  It 'does not output anything without arguments'
    When call echo
    The entire stdout should equal "$LF"
  End

  It 'outputs append with LF'
    When call echo "a"
    The entire stdout should equal "a$LF"
  End

  It 'joins arguments with space and outputs append with LF'
    When call echo "a" "b"
    The entire stdout should equal "a b$LF"
  End

  It 'outputs with raw string append with LF'
    When call echo 'a\b'
    The entire stdout should equal "a\\b$LF"
    The length of entire stdout should equal 4
  End

  Context 'when change IFS'
    It 'joins arguments with spaces'
      BeforeRun 'IFS=@'
      When run echo a b c
      The entire stdout should equal "a b c$LF"
    End
  End
End
