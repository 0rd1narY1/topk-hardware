// 快速选择方法

#include <stdlib.h>
#include <stdio.h>  // for printf
#include <time.h>

void Swap(int a[], int i, int j) 
{
    int tmp = a[i];
    a[i] = a[j];
    a[j] = tmp;
}

// 数组原地分割，取 v = a[start]
// >v 在左，=v 在中，<v在右
// 返回基准元素在整个数组中的位置
// 和快排完全一样
int Partition(int a[], int start, int end) 
{
    int v = a[start];
    int left = start;
    int right = end;
    int i = start;
    while (i <= right) 
    {
        if (a[i] > v) 
        {
            Swap(a, i, left);
            left++;
            i++;
        } 
        else if (a[i] < v) 
        {
            Swap(a, i, right);
            right--;
        } 
        else 
        {
            i++;
        }
    }
    return i - 1;
}

void QuickSelect(int a[], int start, int end, int k) 
{
    if (start >= end || k <= 0) 
        return;

    int p = Partition(a, start, end);
    int m = p + 1;  // 整个数组中在基准元素左边的元素个数

    if (k < m)
        QuickSelect(a, start, p - 1, k);
    else if (k > m)
        QuickSelect(a, p + 1, end, k);  // 注意传 k 而非 k - m ，对齐 m 的意义
    else
        return;
}

// 采用不断分区的办法，找出给定数组中的最大的 k 个数
// 输入原大小为 n 的数组 a
// 函数会原地把 k 大数放到 a 的前 k 个
void TopK(int a[], int n, int k) 
{ 
    return QuickSelect(a, 0, n - 1, k); 
}

int main(void) 
{
    int n, k;
    int *array;
    
    //初始化
    printf("请输入数组长度:");
    scanf("%d",&n);
    printf("请输入k值:");
    scanf("%d",&k);
    array = (int*)malloc(sizeof(int)*n);
    for(int i = 0; i < n; i++)
    {
        printf("请输入第%d个数组元素: ",i);
        scanf("%d",&array[i]);
    }
    printf("数组是:\n");
    for(int i = 0; i < n; i++)
        printf("%d ",array[i]);
    printf("\n");

    struct timespec begin, end; 
    clock_gettime(CLOCK_REALTIME, &begin);
    TopK(array, n, k);
    clock_gettime(CLOCK_REALTIME, &end);

    printf("最小的n-k个数是:\n");
    for (int i = k; i < n; i++)
        printf("%d ", array[i]);
    printf("\n");

    long seconds = end.tv_sec - begin.tv_sec;
    long nanoseconds = end.tv_nsec - begin.tv_nsec;
    double elapsed = seconds + nanoseconds*1e-9;
    printf("Time passed: %.10fs\n",elapsed);
    return 0;
}
