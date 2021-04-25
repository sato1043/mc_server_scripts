#! /bin/bash -e

. ./settings.sh

./cpucores.sh

cd $MC_DIR

java -server \
 -Xmx5G -Xms5G -XX:NewRatio=1 -XX:SurvivorRatio=2 -XX:TargetSurvivorRatio=90 \
 -XX:MetaspaceSize=512M -XX:MaxMetaspaceSize=512M \
 -XX:-UseCompressedOops -XX:-UseCompressedClassPointers \
 -Xss1G \
 -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:InitiatingHeapOccupancyPercent=70 \
 -XX:ParallelGCThreads=4 -XX:ConcGCThreads=2 \
 -XX:+DisableExplicitGC -XX:-UseGCOverheadLimit -XX:+UseTLAB \
 -XX:+UseBiasedLocking \
 -XX:+OptimizeStringConcat \
 -jar $SERVICE nogui

#
# - Javaヒープ
#   - New領域・・・新しいオブジェクトを入れる領域
#     - Eden・・・新規のオブジェクトを入れる領域
#     - Survivor0(S0)・・・GCで生き残ったオブジェクトを入れる領域(Survivor0,Survivor1)
#     - Survivor1(S1)・・・GCで生き残ったオブジェクトを入れる領域(Survivor0,Survivor1)
#   - Old領域・・・生き残っている古いオブジェクトを入れる領域(Tenured)
# - Nativeメモリ
#   - MetaSpace・・・クラスやメソッドなど静的オブジェクトを管理する領域
#   - ConpressedClassSpace・・・MetaSpace同様静的オブジェクトを格納する領域でデフォルト１GBの容量がとられている。
#   - C Heap・・・JVM自身のリソースを格納する領域
#   - Thread Stack・・・静的スレッドを格納する領域
# 
#
# -server
#   プログラム実行速度が最大になるように
#
# -Xmx -Xms
#   Javaヒープサイズ(New領域＋Old領域)
# -XX:NewRatio=1
#    同上 New領域に対するOld領域の比率(デフォルト2)
#    均等に配置するつもり
#  -XX:SurvivorRatio=2
#    同上 New領域のS0/S1に対するEdenの比率（デフォルト8)
#    均等に配置するつもり
#  -XX:TargetSurvivorRatio=90
#    Survivor領域の占有率閾値%。Surviver領域が90％に達したらマイナーGC
#-XX:MaxTenuringThreshold=15 ・・・Survivor領域における移動の回数
#-XX:LargePageSizeInBytes=256m ・・ラージページを使用するための領域確保
#
# -XX:MetaspaceSize=1G -XX:MaxMetaspaceSize=1G \
#   Nativeメモリ、クラス等メタ情報の領域を増やす(MODなどクラスの拡張が多い時)
#
# -XX:-UseCompressedOops -XX:-UseCompressedClassPointers \
#   Nativeメモリ、オブジェクトポインタ32ビット表現を無効化
#   もし有効化する際は -XX:CompressedClassSpaceSize=512M などとサイズ指定する
#
# -Xss Nativeメモリ、ThreadStackサイズ
#
# -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:InitiatingHeapOccupancyPercent=70 \
#   G1GCによるメモリ最適化
#   GC停止時間
#   GC開始のJavaヒープ占有率閾値%
#
# -XX:ParallelGCThreads=4 -XX:ConcGCThreads=2 \
#   GCスレッド数指定。論理コア数に依存する
#
# -XX:+DisableExplicitGC -XX:-UseGCOverheadLimit -XX:+UseTLAB \
#   System.gc()を無効化
#   スワップアウト等でGCに時間が掛かりすぎても処理を中断しない
#   Eden領域をスレッド毎に確保する
#
# -XX:+OptimizeStringConcat \
#   可能なら文字列の連結操作を最適化する
#
# -XX:+UseBiasedLocking \
#   競合しない同期のパフォーマンスを最適化する
#
# jstat -gc -t 80641 1000
# jstat -gcutil -t 80641 1000
#   メモリ使用量の監視
#

#===============================================================
